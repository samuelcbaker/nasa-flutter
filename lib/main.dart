import 'package:flutter/material.dart';
import 'package:nasa_flutter/app.dart';
import 'package:nasa_flutter/di/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppInjection.inject();

  runApp(const NasaApp());
}
