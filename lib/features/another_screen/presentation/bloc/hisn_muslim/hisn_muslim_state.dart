import 'package:quran_app/features/another_screen/data/models/hisn_almuslim_model.dart';

abstract class HisnMuslimState {}

class HisnMuslimInitial extends HisnMuslimState {}

class HisnMuslimLoading extends HisnMuslimState {}

class HisnMuslimLoaded extends HisnMuslimState {
  final List<HisnMuslimModel> hisnMuslim;

  HisnMuslimLoaded(this.hisnMuslim);
}

class HisnMuslimError extends HisnMuslimState {
  final String message;

  HisnMuslimError(this.message);
}
