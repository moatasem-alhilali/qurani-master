// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'hisn_muslim_bloc.dart';

class HisnMuslimState {
  final RequestState state;
  final List<HisnMuslimModel> hisnMuslim;

  HisnMuslimState(
      {this.state = RequestState.initial, this.hisnMuslim = const []});

  HisnMuslimState copyWith({
    RequestState? state,
    List<HisnMuslimModel>? hisnMuslim,
  }) {
    return HisnMuslimState(
      state: state ?? this.state,
      hisnMuslim: hisnMuslim ?? this.hisnMuslim,
    );
  }
}
