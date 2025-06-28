import 'package:doctodoc_mobile/blocs/care_tracking_blocs/display_care_trackings_bloc/display_care_trackings_bloc.dart';
import 'package:doctodoc_mobile/models/care_tracking.dart';
import 'package:doctodoc_mobile/shared/widgets/list_tile/care_tracking_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../appointment/widgets/onboarding_loading.dart';

class CareTrackingTab extends StatefulWidget {
  final ScrollController scrollController;

  const CareTrackingTab({super.key, required this.scrollController});

  @override
  State<CareTrackingTab> createState() => _CareTrackingTabState();
}

class _CareTrackingTabState extends State<CareTrackingTab> {
  bool _isLoadingMore = true;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    _fetchInitialCareTrackings();
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollController.removeListener(_onScroll);
  }

  void _onScroll() {
    if (widget.scrollController.position.pixels >=
            widget.scrollController.position.maxScrollExtent &&
        _isLoadingMore) {
      _fetchNextCareTrackings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocBuilder<DisplayCareTrackingsBloc, DisplayCareTrackingsState>(
              builder: (context, state) {
                return switch (state.status) {
                  DisplayCareTrackingsStatus.initial ||
                  DisplayCareTrackingsStatus.initialLoading =>
                    const OnboardingLoading(),
                  DisplayCareTrackingsStatus.loading ||
                  DisplayCareTrackingsStatus.success =>
                    _buildSuccess(state.careTrackings, state.isLoadingMore),
                  DisplayCareTrackingsStatus.error => _buildError(),
                };
                // return _buildSuccess();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(List<CareTracking> careTrackings, bool isLoadingMore) {
    List<Widget> careTrackingWidgets = careTrackings.map((careTracking) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: CareTrackingListTile(
          title: careTracking.name,
          subtitle: "Détails de ${careTracking.description}",
          pictureUrl: "https://via.placeholder.com/150",
        ),
      );
    }).toList();

    _isLoadingMore = isLoadingMore;

    return Column(
      children: [
        ...careTrackingWidgets,
        if (isLoadingMore) const CircularProgressIndicator() else const Text('Rien à charger'),
      ],
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }

  void _fetchInitialCareTrackings() {
    if (mounted) {
      final bloc = context.read<DisplayCareTrackingsBloc>();
      bloc.add(OnGetInitialCareTrackings());
    }
  }

  void _fetchNextCareTrackings() {
    if (mounted) {
      final bloc = context.read<DisplayCareTrackingsBloc>();
      bloc.add(OnGetNextCareTrackings());
    }
  }
}
