import 'package:flutter/material.dart';
import 'package:nasa_flutter/app.dart';
import 'package:nasa_flutter/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInjection.inject();

  runApp(const NasaApp());
}
