import 'package:dio/dio.dart';
import 'package:nasa_flutter/constants.dart';
import 'package:nasa_flutter/domain/entities/nasa_image.dart';
import 'package:nasa_flutter/domain/exceptions/exceptions.dart';
import 'package:nasa_flutter/extensions/date_extension.dart';
import 'package:nasa_flutter/infra/datasources/api_image_datasource.dart';
import 'package:nasa_flutter/infra/models/nasa_image_model.dart';

class ApiImageDatasourceImpl implements ApiImageDatasource {
  final Dio dio;

  ApiImageDatasourceImpl({required this.dio});

  @override
  Future<List<NasaImage>> getImages(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await dio.get('/planetary/apod', queryParameters: {
      'api_key': nasaApiKey,
      'start_date': startDate.format(),
      'end_date': endDate.format(),
    });

    if (response.data == null || response.data is! List) {
      throw NetworkException();
    }

    // Remove other media types fomr list
    final filteredReponse = (response.data as List).where(
      (image) {
        final imageJson = image as Map<String, dynamic>;
        return imageJson['media_type'] == 'image';
      },
    ).toList();

    return filteredReponse
        .map((image) => NasaImageModel.fromMap(image as Map<String, dynamic>))
        .toList()
        // The reverse was done, because the Nasa API returns the list with the oldest item first
        .reversed
        .toList();
  }
}
