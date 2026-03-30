import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/domain/repositories/young_muslim_repository.dart';

class YoungMuslimQuizCubit extends Cubit<YoungMuslimQuizState> {
  YoungMuslimQuizCubit({
    required YoungMuslimRepository repository,
    required YoungMuslimQuizSetEntity quizSet,
  })  : _repository = repository,
        super(YoungMuslimQuizState(quizSet: quizSet));

  final YoungMuslimRepository _repository;

  void answerQuestion(String questionId, String answer) {
    final updatedAnswers = Map<String, String>.from(state.answers);
    final normalizedAnswer = answer.trim();
    if (normalizedAnswer.isEmpty) {
      updatedAnswers.remove(questionId);
    } else {
      updatedAnswers[questionId] = normalizedAnswer;
    }
    emit(
      state.copyWith(
        answers: updatedAnswers,
        submitState: state.submitState == RequestState.error
            ? RequestState.initial
            : state.submitState,
      ),
    );
  }

  Future<void> submit() async {
    emit(state.copyWith(submitState: RequestState.loading));
    try {
      final result = await _repository.submitQuiz(
        quizId: state.quizSet.id,
        answers: state.answers,
      );
      emit(
        state.copyWith(
          submitState: RequestState.success,
          result: result,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          submitState: RequestState.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}

class YoungMuslimQuizState extends Equatable {
  const YoungMuslimQuizState({
    required this.quizSet,
    this.answers = const {},
    this.submitState = RequestState.initial,
    this.result,
    this.errorMessage,
  });

  final YoungMuslimQuizSetEntity quizSet;
  final Map<String, String> answers;
  final RequestState submitState;
  final YoungMuslimQuizResultEntity? result;
  final String? errorMessage;

  bool get canSubmit => quizSet.questions.every((question) {
        final answer = answers[question.id];
        return answer != null && answer.trim().isNotEmpty;
      });

  YoungMuslimQuizState copyWith({
    Map<String, String>? answers,
    RequestState? submitState,
    YoungMuslimQuizResultEntity? result,
    String? errorMessage,
  }) {
    return YoungMuslimQuizState(
      quizSet: quizSet,
      answers: answers ?? this.answers,
      submitState: submitState ?? this.submitState,
      result: result ?? this.result,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        quizSet,
        answers,
        submitState,
        result,
        errorMessage,
      ];
}
