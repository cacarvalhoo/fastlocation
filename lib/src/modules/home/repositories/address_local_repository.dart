import 'package:hive_flutter/hive_flutter.dart';

import '../../../shared/storage/hive_config.dart';
import '../model/address_model.dart';

class AddressLocalRepository {
  Box get _box => Hive.box(HiveConfig.addressBox);

  /// Salva no histórico; se o CEP já existir, move para o topo.
  Future<void> save(AddressModel address) async {
    final current = getAll();
    current.removeWhere((a) => a.cep == address.cep);
    current.insert(0, address);
    await _box.clear();
    await _box.addAll(current.map((a) => a.toMap()));
  }

  /// Histórico, do mais recente para o mais antigo.
  List<AddressModel> getAll() {
    return _box.values
        .map((e) => AddressModel.fromMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList();
  }

  AddressModel? getLast() {
    final all = getAll();
    return all.isEmpty ? null : all.first;
  }

  Future<void> clear() => _box.clear();
}
