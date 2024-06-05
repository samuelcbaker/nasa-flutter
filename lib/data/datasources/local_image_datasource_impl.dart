import 'package:hive/hive.dart';
import 'package:nasa_flutter/domain/entities/nasa_image.dart';
import 'package:nasa_flutter/extensions/date_extension.dart';
import 'package:nasa_flutter/infra/datasources/local_image_datasource.dart';
import 'package:nasa_flutter/infra/models/nasa_image_model.dart';

class LocalImageDatasourceImpl implements LocalImageDatasource {
  final Box storage;

  LocalImageDatasourceImpl({required this.storage});

  @override
  Future<List<NasaImage>> getImages() async {
    final images = storage
        .toMap()
        .values
        // Parse list map to model
        .map((image) => NasaImageModel.fromJson(image))
        .toList();

    return images;
  }

  @override
  Future<void> saveImages(List<NasaImage> images) async {
    final mapToSave = {
      for (var image in images)
        // Key is the date because it is unique
        image.date.format(): NasaImageModel.fromEntity(image).toJson()
    };
    return storage.putAll(mapToSave);
  }
}
