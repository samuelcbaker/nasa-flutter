import 'package:nasa_flutter/domain/entities/nasa_image.dart';

abstract class LocalImageDatasource {
  Future<List<NasaImage>> getImages();

  Future<void> saveImages(List<NasaImage> images);
}
