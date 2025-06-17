part of 'sabih_bloc.dart';

abstract class SabihEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAllSubihEvent extends SabihEvent {}

class RefreshAllSubihEvent extends SabihEvent {}

class PerformSubihTapEvent extends SabihEvent {
  PerformSubihTapEvent({
    required this.subihId,
    this.from,
    this.to,
  });
  final int subihId;
  final DateTime? from;
  final DateTime? to;

  @override
  List<Object?> get props => [subihId, from, to];
}

enum PeriodType { today, week, month, year, allTime, custom }

class GetCountsForPeriodEvent extends SabihEvent {
  GetCountsForPeriodEvent({
    required this.from,
    required this.to,
    required this.periodType,
  });
  final DateTime from;
  final DateTime to;
  final PeriodType periodType;

  @override
  List<Object?> get props => [from, to, periodType];
}

class ResetTodayCounterEvent extends SabihEvent {
  ResetTodayCounterEvent({
    required this.subihId,
  });
  final int subihId;

  @override
  List<Object?> get props => [subihId];
}

class AddCustomSubihEvent extends SabihEvent {
  AddCustomSubihEvent({
    required this.request,
  });
  final SubihRequest request;

  @override
  List<Object?> get props => [request];
}

class UpdateSubihEvent extends SabihEvent {
  UpdateSubihEvent({
    required this.request,
  });
  final SubihRequest request;

  @override
  List<Object?> get props => [request];
}

class DeleteSubihEvent extends SabihEvent {
  DeleteSubihEvent({
    required this.request,
  });
  final SubihRequest request;

  @override
  List<Object?> get props => [request];
}

class GetAnalyticsDataEvent extends SabihEvent {}
