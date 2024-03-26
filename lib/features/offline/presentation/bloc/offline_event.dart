part of 'offline_bloc.dart';

@immutable
abstract class OfflineEvent {}

class SetStateEvent extends OfflineEvent {}

class GetOfflineEvent extends OfflineEvent {}

class InitOfflinePlayerEvent extends OfflineEvent {
  String type;
  InitOfflinePlayerEvent(this.type);
}
