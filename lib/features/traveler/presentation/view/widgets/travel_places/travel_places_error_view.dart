import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_places/travel_places_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';
import 'package:quran_app/l10n/l10n.dart';

class TravelPlacesErrorView extends StatelessWidget {
  const TravelPlacesErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelPlacesBloc, TravelPlacesState>(
      builder: (context, state) {
        return TravelerNotice(
          icon: AppIcons.error,
          message: state.errorMessage ?? context.l10n.travelerUnexpectedError,
          isError: true,
          actionLabel: context.l10n.commonRetry,
          onAction: () =>
              context.read<TravelPlacesBloc>().add(BootstrapPlacesEvent()),
        );
      },
    );
  }
}
