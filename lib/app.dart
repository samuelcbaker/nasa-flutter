import 'package:flutter/material.dart';
import 'package:nasa_flutter/view/screens/list_images_screen.dart';

class NasaApp extends StatelessWidget {
  const NasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nasa Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: const ListImagesScreen(),
    );
  }
}
