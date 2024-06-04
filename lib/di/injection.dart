import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nasa_flutter/constants.dart';
import 'package:nasa_flutter/data/datasources/api_image_datasource_impl.dart';
import 'package:nasa_flutter/data/datasources/local_image_datasource_impl.dart';
import 'package:nasa_flutter/domain/repositories/image_repository.dart';
import 'package:nasa_flutter/domain/usecases/get_images_usecase.dart';
import 'package:nasa_flutter/infra/datasources/api_image_datasource.dart';
import 'package:nasa_flutter/infra/datasources/local_image_datasource.dart';
import 'package:nasa_flutter/infra/repositories/image_repository_impl.dart';

final getIt = GetIt.instance;

class AppInjection {
  static Future<void> inject() async {
    //Libraries
    getIt.registerSingleton(_getDioInstance());
    final imageBox = await _getImageBox();

    // Datasources
    getIt.registerFactory<ApiImageDatasource>(
      () => ApiImageDatasourceImpl(dio: getIt()),
    );

    getIt.registerFactory<LocalImageDatasource>(
      () => LocalImageDatasourceImpl(storage: imageBox),
    );

    // Repositories
    getIt.registerFactory<ImageRepository>(
      () => ImageRepositoryImpl(
          apiImageDatasource: getIt(), localImageDatasource: getIt()),
    );

    // Usecases
    getIt.registerFactory<GetImagesUsecase>(
      () => GetImagesUsecase(repository: getIt()),
    );

    //Cubit
  }

  static Dio _getDioInstance() {
    return Dio(BaseOptions(
      baseUrl: nasaBaseUrl,
      receiveTimeout: const Duration(seconds: 1),
    ));
  }

  static Future<Box> _getImageBox() async {
    await Hive.initFlutter();
    if (Hive.isBoxOpen(boxImages)) {
      return Hive.box(boxImages);
    } else {
      return Hive.openBox(boxImages);
    }
  }
}
