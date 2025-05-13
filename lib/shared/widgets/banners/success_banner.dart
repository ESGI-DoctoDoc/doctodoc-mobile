import 'package:flutter/material.dart';

import 'base/banner_box_base.dart';

class SuccessBanner extends StatelessWidget {
  final String title;

  const SuccessBanner({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BannerBoxBase(
      title: title,
      severity: BannerSeverity.success,
    );
  }
}
