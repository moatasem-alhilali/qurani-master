part of 'random_ayah_bloc.dart';

@immutable
abstract class RandomAyahEvent {}

class GetRandomAyahEvent extends RandomAyahEvent {}
class RefreshRandomAyahEvent extends RandomAyahEvent {}

