import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';
import 'package:quran_app/features/smart_outreach/data/repo/smart_outreach_session_repository.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_communication_service.dart';

part 'smart_outreach_execution_event.dart';
part 'smart_outreach_execution_state.dart';

class SmartOutreachExecutionBloc
    extends Bloc<SmartOutreachExecutionEvent, SmartOutreachExecutionState> {
  SmartOutreachExecutionBloc({
    required SmartOutreachSessionRepository sessionRepository,
    required SmartOutreachCommunicationService communicationService,
  })  : _sessionRepository = sessionRepository,
        _communicationService = communicationService,
        super(const SmartOutreachExecutionState()) {
    on<StartSmartOutreachSessionEvent>(_onStartSession);
    on<RefreshSmartOutreachSessionEvent>(_onRefreshSession);
    on<RunAutoStepSmartOutreachEvent>(_onRunAutoStep);
    on<LaunchCurrentContactCallEvent>(_onLaunchCall);
    on<SendCurrentContactSmsEvent>(_onSendSms);
    on<MarkCurrentContactAnsweredEvent>(_onMarkAnswered);
    on<MarkCurrentContactNotAnsweredEvent>(_onMarkNotAnswered);
    on<SkipCurrentContactEvent>(_onSkipCurrentContact);
    on<MoveToNextContactEvent>(_onMoveToNext);
    on<FinishSmartOutreachSessionEvent>(_onFinishSession);
    on<ClearSmartOutreachExecutionFeedbackEvent>(_onClearFeedback);
  }

  final SmartOutreachSessionRepository _sessionRepository;
  final SmartOutreachCommunicationService _communicationService;

  Future<void> _onStartSession(
    StartSmartOutreachSessionEvent event,
    Emitter<SmartOutreachExecutionState> emit,
  ) async {
    emit(state.copyWith(loadState: RequestState.loading, message: null));

    final bundle = await _sessionRepository.startOrResumeSession(
      scheduleId: event.scheduleId,
      triggerSource: event.launchedFromNotification
          ? SmartOutreachSessionTriggerSource.notification
          : SmartOutreachSessionTriggerSource.manual,
    );

    if (bundle == null) {
      emit(
        state.copyWith(
          loadState: RequestState.error,
          message: 'تعذر بدء الجلسة. تحقق من إعدادات الجدول.',
        ),
      );
      return;
    }

    final nextState = state.copyWith(
      loadState: RequestState.success,
      sessionBundle: bundle,
      awaitingCallOutcome: false,
      awaitingSmsFallback: false,
      message: null,
    );
    emit(nextState);
    _queueAutoRunIfNeeded(nextState);
  }

  Future<void> _onRefreshSession(
    RefreshSmartOutreachSessionEvent event,
    Emitter<SmartOutreachExecutionState> emit,
  ) async {
    final sessionId = state.sessionBundle?.session.id;
    if (sessionId == null) {
      return;
    }

    final bundle = await _sessionRepository.getSessionById(sessionId);
    if (bundle == null) {
      return;
    }

    emit(
      state.copyWith(
        sessionBundle: bundle,
      ),
    );
  }

  Future<void> _onLaunchCall(
    LaunchCurrentContactCallEvent event,
    Emitter<SmartOutreachExecutionState> emit,
  ) async {
    final bundle = state.sessionBundle;
    final contact = state.currentContact;

    if (bundle == null || contact == null) {
      return;
    }

    if (!contact.actionType.includesCall) {
      emit(
        state.copyWith(
          message: 'هذا الإجراء لا يدعم الاتصال.',
        ),
      );
      return;
    }

    final launched =
        await _communicationService.launchCallDialer(contact.phone);

    if (!launched) {
      emit(
        state.copyWith(
          message: 'تعذر بدء الاتصال.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        awaitingCallOutcome: true,
        awaitingSmsFallback: false,
        message: null,
      ),
    );
  }

  Future<void> _onRunAutoStep(
    RunAutoStepSmartOutreachEvent event,
    Emitter<SmartOutreachExecutionState> emit,
  ) async {
    final bundle = state.sessionBundle;
    final contact = state.currentContact;

    if (bundle == null || contact == null) {
      return;
    }

    if (!state.autoPilotEnabled || state.awaitingCallOutcome) {
      return;
    }

    if (bundle.isContactCompleted(contact)) {
      add(const MoveToNextContactEvent());
      return;
    }

    if (contact.actionType.includesCall && !state.awaitingSmsFallback) {
      add(const LaunchCurrentContactCallEvent());
      return;
    }

    if (contact.actionType.includesSms &&
        (!contact.actionType.includesCall || state.awaitingSmsFallback)) {
      add(const SendCurrentContactSmsEvent());
    }
  }

  Future<void> _onSendSms(
    SendCurrentContactSmsEvent event,
    Emitter<SmartOutreachExecutionState> emit,
  ) async {
    final bundle = state.sessionBundle;
    final contact = state.currentContact;

    if (bundle == null || contact == null) {
      return;
    }

    if (!contact.actionType.includesSms) {
      emit(
        state.copyWith(
          message: 'هذا الإجراء لا يدعم الرسائل.',
        ),
      );
      return;
    }

    final smsBody = _resolveSmsTemplate(bundle, contact);

    final launched = await _communicationService.launchSmsComposer(
      phone: contact.phone,
      message: smsBody,
    );

    if (!launched) {
      emit(
        state.copyWith(
          message: 'تعذر إرسال الرسالة.',
        ),
      );
      return;
    }

    final contactId = contact.id;
    final sessionId = bundle.session.id;
    if (contactId == null || sessionId == null) {
      emit(
        state.copyWith(
          message: 'تعذر تحديث تقدم الجلسة.',
        ),
      );
      return;
    }

    final updated = await _sessionRepository.addContactResultAndRefresh(
      sessionId: sessionId,
      contactId: contactId,
      resultType: SmartOutreachContactResultType.smsSent,
    );

    if (updated == null) {
      emit(
        state.copyWith(
          message: 'تعذر تحديث تقدم الجلسة.',
        ),
      );
      return;
    }

    final nextState = state.copyWith(
      sessionBundle: updated,
      awaitingCallOutcome: false,
      awaitingSmsFallback: false,
      message: null,
    );

    emit(nextState);
    _queueAutoRunIfNeeded(nextState);
  }

  Future<void> _onMarkAnswered(
    MarkCurrentContactAnsweredEvent event,
    Emitter<SmartOutreachExecutionState> emit,
  ) async {
    await _addResultForCurrentContact(
      emit,
      resultType: SmartOutreachContactResultType.answered,
      setAwaitingCallOutcome: false,
      setAwaitingSmsFallback: false,
    );
  }

  Future<void> _onMarkNotAnswered(
    MarkCurrentContactNotAnsweredEvent event,
    Emitter<SmartOutreachExecutionState> emit,
  ) async {
    final bundle = state.sessionBundle;
    final contact = state.currentContact;

    if (bundle == null || contact == null) {
      return;
    }

    final contactId = contact.id;
    final sessionId = bundle.session.id;

    if (contactId == null || sessionId == null) {
      emit(
        state.copyWith(
          message: 'تعذر تحديث تقدم الجلسة.',
        ),
      );
      return;
    }

    final updated = await _sessionRepository.addContactResultAndRefresh(
      sessionId: sessionId,
      contactId: contactId,
      resultType: SmartOutreachContactResultType.notAnswered,
    );

    if (updated == null) {
      emit(
        state.copyWith(
          message: 'تعذر تحديث تقدم الجلسة.',
        ),
      );
      return;
    }

    final shouldSuggestSms =
        contact.actionType == SmartOutreachActionType.callThenSms;

    final nextState = state.copyWith(
      sessionBundle: updated,
      awaitingCallOutcome: false,
      awaitingSmsFallback: shouldSuggestSms,
      message: shouldSuggestSms
          ? 'تم تسجيل عدم الرد. سيتم إرسال رسالة تلقائيًا.'
          : null,
    );

    emit(nextState);

    if (shouldSuggestSms && nextState.autoPilotEnabled) {
      add(const SendCurrentContactSmsEvent());
      return;
    }

    _queueAutoRunIfNeeded(nextState);
  }

  Future<void> _onSkipCurrentContact(
    SkipCurrentContactEvent event,
    Emitter<SmartOutreachExecutionState> emit,
  ) async {
    await _addResultForCurrentContact(
      emit,
      resultType: SmartOutreachContactResultType.skipped,
      setAwaitingCallOutcome: false,
      setAwaitingSmsFallback: false,
    );
  }

  Future<void> _onMoveToNext(
    MoveToNextContactEvent event,
    Emitter<SmartOutreachExecutionState> emit,
  ) async {
    final bundle = state.sessionBundle;
    final contact = state.currentContact;

    if (bundle == null || contact == null) {
      return;
    }

    if (!bundle.isContactCompleted(contact)) {
      await _onSkipCurrentContact(const SkipCurrentContactEvent(), emit);
      return;
    }

    final sessionId = bundle.session.id;
    if (sessionId == null) {
      return;
    }

    if (bundle.isFullyCompleted) {
      add(const FinishSmartOutreachSessionEvent());
      return;
    }

    final nextIndex = (bundle.session.currentIndex + 1)
        .clamp(0, bundle.scheduleBundle.contacts.length - 1);

    final moved = await _sessionRepository.moveToIndex(
      sessionId: sessionId,
      index: nextIndex,
    );

    if (moved == null) {
      return;
    }

    final nextState = state.copyWith(
      sessionBundle: moved,
      awaitingCallOutcome: false,
      awaitingSmsFallback: false,
    );
    emit(nextState);
    _queueAutoRunIfNeeded(nextState);
  }

  Future<void> _onFinishSession(
    FinishSmartOutreachSessionEvent event,
    Emitter<SmartOutreachExecutionState> emit,
  ) async {
    final bundle = state.sessionBundle;
    final sessionId = bundle?.session.id;
    if (bundle == null || sessionId == null) {
      return;
    }

    final finished = await _sessionRepository.finishSession(
      sessionId,
      markRemainingAsSkipped: true,
    );

    if (finished == null) {
      emit(
        state.copyWith(message: 'تعذر إنهاء الجلسة.'),
      );
      return;
    }

    emit(
      state.copyWith(
        sessionBundle: finished,
        awaitingCallOutcome: false,
        awaitingSmsFallback: false,
        message: 'تم إنهاء الجلسة بنجاح.',
      ),
    );
  }

  void _onClearFeedback(
    ClearSmartOutreachExecutionFeedbackEvent event,
    Emitter<SmartOutreachExecutionState> emit,
  ) {
    emit(state.copyWith(message: null));
  }

  Future<void> _addResultForCurrentContact(
    Emitter<SmartOutreachExecutionState> emit, {
    required SmartOutreachContactResultType resultType,
    required bool setAwaitingCallOutcome,
    required bool setAwaitingSmsFallback,
  }) async {
    final bundle = state.sessionBundle;
    final contact = state.currentContact;

    if (bundle == null || contact == null) {
      return;
    }

    final contactId = contact.id;
    final sessionId = bundle.session.id;

    if (contactId == null || sessionId == null) {
      emit(
        state.copyWith(
          message: 'تعذر تحديث تقدم الجلسة.',
        ),
      );
      return;
    }

    final updated = await _sessionRepository.addContactResultAndRefresh(
      sessionId: sessionId,
      contactId: contactId,
      resultType: resultType,
    );

    if (updated == null) {
      emit(
        state.copyWith(
          message: 'تعذر تحديث تقدم الجلسة.',
        ),
      );
      return;
    }

    final nextState = state.copyWith(
      sessionBundle: updated,
      awaitingCallOutcome: setAwaitingCallOutcome,
      awaitingSmsFallback: setAwaitingSmsFallback,
      message: null,
    );
    emit(nextState);
    _queueAutoRunIfNeeded(nextState);
  }

  String _resolveSmsTemplate(
    SmartOutreachSessionBundle bundle,
    SmartOutreachContactModel contact,
  ) {
    final contactTemplate = contact.smsTemplate?.trim();
    if (contactTemplate != null && contactTemplate.isNotEmpty) {
      return contactTemplate;
    }

    final scheduleTemplate = bundle.scheduleBundle.schedule.smsTemplate?.trim();
    if (scheduleTemplate != null && scheduleTemplate.isNotEmpty) {
      return scheduleTemplate;
    }

    return 'السلام عليكم، حاولت التواصل معك. فضلاً تواصل معي عند التوفر.';
  }

  void _queueAutoRunIfNeeded(SmartOutreachExecutionState nextState) {
    if (!nextState.autoPilotEnabled ||
        nextState.isCompleted ||
        nextState.awaitingCallOutcome ||
        nextState.currentContact == null) {
      return;
    }

    add(const RunAutoStepSmartOutreachEvent());
  }
}
