import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../metrics/app_metrics.dart';

/// Tela/indicador de loading exibido durante consultas externas.
class AppLoading extends StatelessWidget {
  final String message;

  const AppLoading({super.key, this.message = 'Consultando...'});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: AppMetrics.spaceMd),
            Text(
              message,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}