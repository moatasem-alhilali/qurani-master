part of 'quran_plan_bloc.dart';

abstract class QuranPlanEvent extends Equatable {
  const QuranPlanEvent();
  @override
  List<Object?> get props => [];
}

class LoadAllPlansEvent extends QuranPlanEvent {}

class CreatePlanEvent extends QuranPlanEvent {
  const CreatePlanEvent(this.plan, this.fromJuz, this.toJuz, this.totalDays);
  final QuranPlan plan;
  final int fromJuz;
  final int toJuz;
  final int totalDays;
  @override
  List<Object?> get props => [plan, fromJuz, toJuz, totalDays];
}

class UpdatePlanEvent extends QuranPlanEvent {
  const UpdatePlanEvent(this.plan);
  final QuranPlan plan;
  @override
  List<Object?> get props => [plan];
}

class DeletePlanEvent extends QuranPlanEvent {
  const DeletePlanEvent(this.planId);
  final int planId;
  @override
  List<Object?> get props => [planId];
}

class LoadSessionsEvent extends QuranPlanEvent {
  const LoadSessionsEvent(this.planId);
  final int planId;
  @override
  List<Object?> get props => [planId];
}

class CompleteSessionEvent extends QuranPlanEvent {
  const CompleteSessionEvent(this.sessionId, this.planId);
  final int sessionId;
  final int planId;
  @override
  List<Object?> get props => [sessionId, planId];
}

class LoadNextSessionEvent extends QuranPlanEvent {
  const LoadNextSessionEvent(this.planId);
  final int planId;
  @override
  List<Object?> get props => [planId];
}