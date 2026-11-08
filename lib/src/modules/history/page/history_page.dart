import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../../home/components/empty_search.dart';
import '../../home/model/address_model.dart';
import '../controller/history_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryController _controller = HistoryController();

  @override
  void initState() {
    super.initState();
    _controller.load();
  }

  Future<void> _openMap(AddressModel address) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await MapLauncher.directions(.search(address.geocodeQuery)).show();
    } on MapLaunchException {
      messenger.showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o mapa.')),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Erro ao abrir o mapa.')),
      );
    }
  }

  Future<void> _confirmClear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpar histórico'),
        content: const Text('Deseja apagar todos os endereços consultados?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Apagar'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _controller.clear();
    }
  }

  String _subtitle(AddressModel a) {
    final area = [
      a.bairro,
      '${a.localidade}-${a.uf}',
    ].where((p) => p.trim().isNotEmpty && p != '-').join(' • ');
    return '$area\nCEP ${a.cep}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Histórico'),
        actions: [
          Observer(
            builder: (_) {
              if (_controller.items.isEmpty) return const SizedBox.shrink();
              return IconButton(
                tooltip: 'Limpar histórico',
                icon: const Icon(Icons.delete_outline),
                onPressed: _confirmClear,
              );
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (_controller.items.isEmpty) {
            return const EmptySearch(
              message: 'Nenhum endereço consultado ainda.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppMetrics.spaceMd),
            itemCount: _controller.items.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppMetrics.spaceSm),
            itemBuilder: (_, index) {
              final address = _controller.items[index];
              return Card(
                elevation: 0,
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppMetrics.radius),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    address.logradouro.isEmpty
                        ? 'CEP ${address.cep}'
                        : address.logradouro,
                  ),
                  subtitle: Text(_subtitle(address)),
                  isThreeLine: true,
                  trailing: const Icon(
                    Icons.directions,
                    color: AppColors.primary,
                  ),
                  onTap: () => _openMap(address),
                ),
              );
            },
          );
        },
      ),
    );
  }
}