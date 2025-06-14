

import 'package:doctodoc_mobile/shared/widgets/list_tile/care_tracking_list_tile.dart';
import 'package:flutter/material.dart';

class CareTrackingTab extends StatefulWidget {
  final ScrollController? scrollController;

  const CareTrackingTab({super.key, this.scrollController});

  @override
  State<CareTrackingTab> createState() => _CareTrackingTabState();
}

class _CareTrackingTabState extends State<CareTrackingTab> {
  bool _isLoadingMore = true;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
    // _fetchInitialCareTracking();
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollController?.removeListener(_onScroll);
  }

  void _onScroll() {
    // if (widget.scrollController.position.pixels >= widget.scrollController.position.maxScrollExtent &&
    //     _isLoadingMore) {
    // _fetchMoreCareTracking();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSuccess([
                  'Vaccin contre la grippe',
                  'Ordonnance pour le diabète',
                  'Résultats de la prise de sang',
                  'Certificat médical pour le sport',
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(List<String> careTrackingItems) {
   List<Widget> careTrackingWidgets = careTrackingItems.map((item) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: CareTrackingListTile(title: "$item"),
      );
    }).toList();

    return Column(children: careTrackingWidgets);
  }
}
