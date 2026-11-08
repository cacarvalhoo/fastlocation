import 'package:dio/dio.dart';

import '../model/address_model.dart';
import '../repositories/address_api_repository.dart';
import '../repositories/address_local_repository.dart';

class AddressException implements Exception {
  final String message;
  const AddressException(this.message);

  @override
  String toString() => message;
}

class AddressService {
  final AddressApiRepository _api;
  final AddressLocalRepository _local;

  AddressService({AddressApiRepository? api, AddressLocalRepository? local})
    : _api = api ?? AddressApiRepository(),
      _local = local ?? AddressLocalRepository();

  /// Retorna o endereço ou null se não encontrado.
  Future<AddressModel?> searchByCep(String cep) async {
    final clean = cep.replaceAll(RegExp(r'\D'), '');
    if (clean.length != 8) {
      throw const AddressException('Informe um CEP com 8 dígitos.');
    }
    try {
      final address = await _api.findByCep(clean);
      if (address != null) await _local.save(address);
      return address;
    } on DioException catch (e) {
      throw AddressException(_dioMessage(e, byCep: true));
    }
  }

  /// Busca por endereço; devolve a lista de resultados (pode ser vazia).
  Future<List<AddressModel>> searchByAddress({
    required String uf,
    required String city,
    required String street,
  }) async {
    if (uf.trim().length != 2) {
      throw const AddressException('Informe a UF com 2 letras (ex.: SC).');
    }
    if (city.trim().length < 3) {
      throw const AddressException('Informe a cidade (mín. 3 letras).');
    }
    if (street.trim().length < 3) {
      throw const AddressException('Informe o logradouro (mín. 3 letras).');
    }
    try {
      return await _api.findByAddress(
        uf: uf.trim(),
        city: city.trim(),
        street: street.trim(),
      );
    } on DioException catch (e) {
      throw AddressException(_dioMessage(e, byCep: false));
    }
  }

  /// Quando o usuário escolhe um item da busca por endereço.
  Future<void> saveToHistory(AddressModel address) => _local.save(address);

  AddressModel? getLastAddress() => _local.getLast();

  List<AddressModel> getHistory() => _local.getAll();

  Future<void> clearHistory() => _local.clear();

  String _dioMessage(DioException e, {required bool byCep}) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Sem conexão com a internet. Tente novamente.';
    }
    if (e.response?.statusCode == 400) {
      return byCep
          ? 'CEP inválido.'
          : 'Consulta inválida. Confira UF, cidade e logradouro.';
    }
    return 'Erro ao consultar o endereço. Tente novamente.';
  }
}