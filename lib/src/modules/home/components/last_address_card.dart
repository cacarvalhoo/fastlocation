import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../model/address_model.dart';

/// Mostra o último endereço consultado.
class LastAddressCard extends StatelessWidget {
  final AddressModel address;

  const LastAddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppMetrics.radius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppMetrics.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Último endereço consultado',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: AppMetrics.spaceSm),
            Text(
              'CEP ${address.cep}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppMetrics.spaceXs),
            Text(
              address.logradouro.isEmpty
                  ? '(sem logradouro)'
                  : address.logradouro,
              style: const TextStyle(fontSize: 16),
            ),
            if (address.complemento.isNotEmpty) Text(address.complemento),
            Text(address.bairro),
            Text('${address.localidade} - ${address.uf}'),
          ],
        ),
      ),
    );
  }
}
