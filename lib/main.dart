import 'package:flutter/material.dart';

import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // No passo 03 vamos inicializar o Hive aqui.
  runApp(const App());
}