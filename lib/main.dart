import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/shared/storage/hive_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  runApp(const App());
}