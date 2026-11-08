import 'package:dio/dio.dart';

import '../../../http/http_client.dart';
import '../model/address_model.dart';

class AddressApiRepository {
  final Dio _dio;

  AddressApiRepository({Dio? dio}) : _dio = dio ?? HttpClient.create();

  /// Consulta por CEP. Retorna null se o CEP não existir.
  Future<AddressModel?> findByCep(String cep) async {
    final clean = cep.replaceAll(RegExp(r'\D'), '');
    final response = await _dio.get('/$clean/json/');
    final data = response.data;
    if (data is Map && data['erro'] == true) return null;
    return AddressModel.fromJson(Map<String, dynamic>.from(data as Map));
  }

  /// Busca CEPs por UF + cidade + logradouro (completo ou parcial).
  Future<List<AddressModel>> findByAddress({
    required String uf,
    required String city,
    required String street,
  }) async {
    final response = await _dio.get(
      '/${Uri.encodeComponent(uf)}/${Uri.encodeComponent(city)}/${Uri.encodeComponent(street)}/json/',
    );
    final data = response.data;
    if (data is! List) return [];
    return data
        .map((e) => AddressModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}