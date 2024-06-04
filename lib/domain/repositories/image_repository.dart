import 'package:nasa_flutter/domain/entities/nasa_image.dart';

abstract class ImageRepository {
  Future<List<NasaImage>> getImages(DateTime startDate, DateTime endDate);
}
