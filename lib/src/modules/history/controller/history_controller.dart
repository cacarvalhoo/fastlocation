import 'package:mobx/mobx.dart';

import '../../home/model/address_model.dart';
import '../../home/service/address_service.dart';

class HistoryController {
  final AddressService _service;

  HistoryController({AddressService? service})
    : _service = service ?? AddressService();

  /// Histórico observável, do mais recente para o mais antigo.
  final ObservableList<AddressModel> items = ObservableList<AddressModel>();

  void load() {
    runInAction(() {
      items
        ..clear()
        ..addAll(_service.getHistory());
    });
  }

  Future<void> clear() async {
    await _service.clearHistory();
    load();
  }
}