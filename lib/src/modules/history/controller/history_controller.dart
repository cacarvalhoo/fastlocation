import 'package:mobx/mobx.dart';

import '../../home/model/address_model.dart';
import '../../home/service/address_service.dart';

part 'history_controller.g.dart';

class HistoryController = _HistoryControllerBase with _$HistoryController;

abstract class _HistoryControllerBase with Store {
  final AddressService _service;

  _HistoryControllerBase({AddressService? service})
    : _service = service ?? AddressService();

  /// Histórico observável, do mais recente para o mais antigo.
  @observable
  ObservableList<AddressModel> items = ObservableList<AddressModel>();

  /// Carrega o histórico do armazenamento local.
  @action
  void load() {
    items
      ..clear()
      ..addAll(_service.getHistory());
  }

  /// Apaga o histórico e recarrega a lista.
  @action
  Future<void> clear() async {
    await _service.clearHistory();
    load();
  }
}