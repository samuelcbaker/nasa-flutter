import 'package:nasa_flutter/domain/entities/nasa_image.dart';

abstract class ApiImageDatasource {
  Future<List<NasaImage>> getImages(DateTime startDate, DateTime endDate);
}
