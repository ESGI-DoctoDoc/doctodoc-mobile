import 'package:flutter/material.dart';

import 'base/banner_box_base.dart';

class WarningBanner extends StatelessWidget {
  final String title;

  const WarningBanner({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BannerBoxBase(
      title: title,
      severity: BannerSeverity.warning,
    );
  }
}