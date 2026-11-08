import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:mobx/mobx.dart';

import '../../../routes/app_routes.dart';
import '../../../shared/colors/app_colors.dart';
import '../../../shared/components/app_loading.dart';
import '../../../shared/components/app_primary_button.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../components/address_list.dart';
import '../components/empty_search.dart';
import '../components/last_address_card.dart';
import '../controller/home_controller.dart';

import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();

  final _cepCtrl = TextEditingController();
  final _ufCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();

  bool _byCep = true;
  late final ReactionDisposer _errorReaction;

  @override
  void initState() {
    super.initState();
    _controller.loadLast();

    // Reaction: mostra SnackBar sempre que houver mensagem de erro.
    _errorReaction = reaction<String?>((_) => _controller.errorMessage, (msg) {
      if (msg == null || !mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: AppColors.error),
      );
      _controller.clearError();
    });
  }

  @override
  void dispose() {
    _errorReaction();
    _cepCtrl.dispose();
    _ufCtrl.dispose();
    _cityCtrl.dispose();
    _streetCtrl.dispose();
    super.dispose();
  }

  /// Remove vírgula e número do fim do logradouro (o ViaCEP só aceita o nome da rua).
  /// "Rua Bom Pastor, 1457" e "Rua Bom Pastor 1457" viram "Rua Bom Pastor".
  String _cleanStreet(String raw) {
    final beforeComma = raw.split(',').first;
    return beforeComma
        .replaceAll(RegExp(r'\s+\d+\s*$'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  void _search() {
    FocusScope.of(context).unfocus();
    if (_byCep) {
      _controller.searchByCep(_cepCtrl.text);
    } else {
      _controller.searchByAddress(
        uf: _ufCtrl.text,
        city: _cityCtrl.text,
        street: _cleanStreet(_streetCtrl.text),
      );
    }
  }

  void _newSearch() {
    _cepCtrl.clear();
    _ufCtrl.clear();
    _cityCtrl.clear();
    _streetCtrl.clear();
    _controller.results.clear();
    _controller.notFound = false;
  }

  Future<void> _openHistory() async {
    await Navigator.of(context).pushNamed(AppRoutes.history);
    _controller.loadLast();
  }

  Future<void> _traceRoute() async {
    final address = _controller.lastAddress;
    if (address == null) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      // Destino em texto: o Google Maps resolve o endereço e mostra o nome da rua.
      await MapLauncher.directions(.search(address.geocodeQuery)).show();
    } on MapLaunchException {
      messenger.showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o mapa.')),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Erro ao traçar a rota.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('FastLocation'),
        actions: [
          IconButton(
            tooltip: 'Histórico',
            icon: const Icon(Icons.history),
            onPressed: _openHistory,
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (_controller.isLoading) {
            return const AppLoading();
          }
          return ListView(
            padding: const EdgeInsets.all(AppMetrics.spaceMd),
            children: [
              _buildModeSelector(),
              const SizedBox(height: AppMetrics.spaceMd),
              _buildForm(),
              const SizedBox(height: AppMetrics.spaceMd),
              AppPrimaryButton(label: 'Consultar', onPressed: _search),
              const SizedBox(height: AppMetrics.spaceSm),
              TextButton.icon(
                onPressed: _newSearch,
                icon: const Icon(Icons.refresh),
                label: const Text('Nova consulta'),
              ),
              const SizedBox(height: AppMetrics.spaceMd),
              ..._buildResultArea(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildModeSelector() {
    return SegmentedButton<bool>(
      segments: const [
        ButtonSegment(value: true, label: Text('Por CEP')),
        ButtonSegment(value: false, label: Text('Por endereço')),
      ],
      selected: {_byCep},
      onSelectionChanged: (s) => setState(() => _byCep = s.first),
    );
  }

  Widget _buildForm() {
    if (_byCep) {
      return TextField(
        controller: _cepCtrl,
        keyboardType: TextInputType.number,
        maxLength: 8,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          labelText: 'CEP',
          hintText: '88101000',
          border: OutlineInputBorder(),
        ),
      );
    }
    return Column(
      children: [
        TextField(
          controller: _ufCtrl,
          maxLength: 2,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'UF',
            hintText: 'SC',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppMetrics.spaceSm),
        TextField(
          controller: _cityCtrl,
          decoration: const InputDecoration(
            labelText: 'Cidade',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppMetrics.spaceSm),
        TextField(
          controller: _streetCtrl,
          decoration: const InputDecoration(
            labelText: 'Logradouro (completo ou parcial)',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildResultArea() {
    if (_controller.notFound) {
      return const [EmptySearch()];
    }
    if (_controller.results.isNotEmpty) {
      return [
        const Text(
          'Resultados (toque para selecionar)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        AddressList(
          shrinkWrap: true,
          addresses: _controller.results.toList(),
          onTap: _controller.selectResult,
        ),
      ];
    }
    final last = _controller.lastAddress;
    if (last != null) {
      return [
        LastAddressCard(address: last),
        const SizedBox(height: AppMetrics.spaceMd),
        AppPrimaryButton(
          label: 'Traçar rota',
          icon: Icons.directions,
          onPressed: _traceRoute,
        ),
      ];
    }
    return const [
      EmptySearch(message: 'Faça uma consulta para ver o endereço aqui.'),
    ];
  }
}
