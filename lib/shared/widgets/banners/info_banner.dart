import 'package:flutter/material.dart';

import 'base/banner_box_base.dart';

class InfoBanner extends StatelessWidget {
  final String title;

  const InfoBanner({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BannerBoxBase(
      title: title,
      severity: BannerSeverity.info,
    );
  }
}
