import 'package:flutter/foundation.dart';
import 'package:nasa_flutter/domain/entities/nasa_image.dart';
import 'package:nasa_flutter/domain/exceptions/exceptions.dart';
import 'package:nasa_flutter/domain/repositories/image_repository.dart';
import 'package:nasa_flutter/infra/datasources/api_image_datasource.dart';
import 'package:nasa_flutter/infra/datasources/local_image_datasource.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ApiImageDatasource apiImageDatasource;
  final LocalImageDatasource localImageDatasource;

  ImageRepositoryImpl({
    required this.apiImageDatasource,
    required this.localImageDatasource,
  });

  @override
  Future<List<NasaImage>> getImages(
    DateTime startDate,
    DateTime endDate,
  ) async {
    List<NasaImage>? result;

    // First, try to search on API
    try {
      result = await apiImageDatasource.getImages(startDate, endDate);
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      if (result != null) {
        // If API returns a list try save images
        localImageDatasource.saveImages(result);
      } else {
        // If API didnt return a list try get saved images
        result = await localImageDatasource.getImages();
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    if (result == null || result.isEmpty) {
      throw NotFoundItemsException();
    }

    return result;
  }
}
