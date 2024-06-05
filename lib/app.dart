import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_flutter/di/injection.dart';
import 'package:nasa_flutter/view/cubit/connectivity/connectivity_cubit.dart';
import 'package:nasa_flutter/view/cubit/list_images/list_images_cubit.dart';
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
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ListImagesCubit>(
            create: (context) => getIt(),
          ),
          BlocProvider<ConnectivityCubit>(
            create: (context) => getIt(),
          ),
        ],
        child: const ListImagesScreen(),
      ),
    );
  }
}
