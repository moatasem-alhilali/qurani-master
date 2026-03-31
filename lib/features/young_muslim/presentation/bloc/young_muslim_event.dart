part of 'young_muslim_bloc.dart';

@immutable
sealed class YoungMuslimEvent extends Equatable {
  const YoungMuslimEvent();

  @override
  List<Object?> get props => [];
}

class YoungMuslimStarted extends YoungMuslimEvent {
  const YoungMuslimStarted();
}

class YoungMuslimRefreshed extends YoungMuslimEvent {
  const YoungMuslimRefreshed();
}

class YoungMuslimSearchChanged extends YoungMuslimEvent {
  const YoungMuslimSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class YoungMuslimFiltersChanged extends YoungMuslimEvent {
  const YoungMuslimFiltersChanged(this.filters);

  final YoungMuslimFilters filters;

  @override
  List<Object?> get props => [filters];
}

class YoungMuslimCategoryRequested extends YoungMuslimEvent {
  const YoungMuslimCategoryRequested(this.categoryId);

  final String categoryId;

  @override
  List<Object?> get props => [categoryId];
}

class YoungMuslimVideoRequested extends YoungMuslimEvent {
  const YoungMuslimVideoRequested(this.videoId);

  final String videoId;

  @override
  List<Object?> get props => [videoId];
}

class YoungMuslimFavoriteToggled extends YoungMuslimEvent {
  const YoungMuslimFavoriteToggled(this.videoId);

  final String videoId;

  @override
  List<Object?> get props => [videoId];
}

class YoungMuslimWatchLaterToggled extends YoungMuslimEvent {
  const YoungMuslimWatchLaterToggled(this.videoId);

  final String videoId;

  @override
  List<Object?> get props => [videoId];
}
