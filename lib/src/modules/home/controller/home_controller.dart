import 'package:mobx/mobx.dart';

import '../model/address_model.dart';
import '../service/address_service.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final AddressService _service;

  _HomeControllerBase({AddressService? service})
      : _service = service ?? AddressService();

  @observable
  bool isLoading = false;

  /// Mensagem de erro (observada por uma reaction na page).
  @observable
  String? errorMessage;

  /// Último endereço consultado.
  @observable
  AddressModel? lastAddress;

  /// true quando a última busca não achou nada.
  @observable
  bool notFound = false;

  /// Resultados da busca por endereço.
  @observable
  ObservableList<AddressModel> results = ObservableList<AddressModel>();

  @action
  void loadLast() {
    lastAddress = _service.getLastAddress();
  }

  @action
  Future<void> searchByCep(String cep) async {
    isLoading = true;
    errorMessage = null;
    notFound = false;
    results.clear();
    try {
      final address = await _service.searchByCep(cep);
      if (address == null) {
        notFound = true;
      } else {
        lastAddress = address;
      }
    } on AddressException catch (e) {
      errorMessage = e.message;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> searchByAddress({
    required String uf,
    required String city,
    required String street,
  }) async {
    isLoading = true;
    errorMessage = null;
    notFound = false;
    results.clear();
    try {
      final list = await _service.searchByAddress(
        uf: uf,
        city: city,
        street: street,
      );
      if (list.isEmpty) {
        notFound = true;
      } else {
        results.addAll(list);
      }
    } on AddressException catch (e) {
      errorMessage = e.message;
    } finally {
      isLoading = false;
    }
  }

  /// Usuário escolheu um item da lista de resultados.
  @action
  Future<void> selectResult(AddressModel address) async {
    await _service.saveToHistory(address);
    lastAddress = address;
    results.clear();
  }

  @action
  void clearError() => errorMessage = null;
}