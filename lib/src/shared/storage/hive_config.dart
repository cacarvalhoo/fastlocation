import 'package:hive_flutter/hive_flutter.dart';

class HiveConfig {
  HiveConfig._();

  /// Caixa que guarda o histórico de endereços consultados (como Map).
  static const String addressBox = 'address_box';

  static Future<void> start() async {
    // hive_flutter usa o path_provider por baixo e inicializa o Hive.
    await Hive.initFlutter();
    await Hive.openBox(addressBox);
  }
}
