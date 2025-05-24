import 'package:doctodoc_mobile/screens/appointment/widgets/appointment_label.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/onboarding_loading.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/inputs/care_tracking_selection.dart';

class AppointmentStepCareTracking extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(String) onNext;
  final VoidCallback? onEmpty;

  const AppointmentStepCareTracking({
    super.key,
    required this.formKey,
    required this.onNext,
    this.onEmpty,
  });

  @override
  State<AppointmentStepCareTracking> createState() => _AppointmentStepCareTrackingState();
}

class _AppointmentStepCareTrackingState extends State<AppointmentStepCareTracking> {
  final TextEditingController _careTrackingController = TextEditingController();
  bool _isLoading = true;
  bool _hasError = false;
  List<CareTrackingItem> _careTrackings = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        _isLoading = false;
        _careTrackings = const [];
      });

      if (_careTrackings.isEmpty) {
        widget.onEmpty?.call();
      }
    });
  }

  Widget _buildSuccess() {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const AppointmentLabel(
                label: "Souhaitez-vous lier ce rendez-vous avec votre suivi de dossier ?",
              ),
              const SizedBox(height: 10),
              if (_careTrackings.isEmpty)
                const Text(
                  "Aucun suivi de dossier n'est disponible pour le moment.",
                ),
              CareTrackingSelection(
                controller: _careTrackingController,
                careTrackings: _careTrackings,
                required: false,
                onChange: (item) {
                  print("Selected care tracking: ${item.label}");
                  widget.onNext(item.value);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const OnboardingLoading();
    } else if (_hasError) {
      return _buildError();
    } else {
      return _buildSuccess();
    }
  }
}
