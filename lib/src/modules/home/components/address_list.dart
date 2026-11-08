import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';
import '../model/address_model.dart';

/// Lista de endereços (resultados da busca ou histórico).
class AddressList extends StatelessWidget {
  final List<AddressModel> addresses;
  final ValueChanged<AddressModel>? onTap;
  final bool shrinkWrap;

  const AddressList({
    super.key,
    required this.addresses,
    this.onTap,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: addresses.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final a = addresses[i];
        return ListTile(
          leading: const Icon(Icons.place, color: AppColors.primary),
          title: Text(a.logradouro.isEmpty ? 'CEP ${a.cep}' : a.logradouro),
          subtitle: Text('${a.bairro} • ${a.localidade}-${a.uf}\nCEP ${a.cep}'),
          isThreeLine: true,
          onTap: onTap == null ? null : () => onTap!(a),
        );
      },
    );
  }
}