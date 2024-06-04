import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:nasa_flutter/domain/entities/nasa_image.dart';
import 'package:nasa_flutter/extensions/list_extension.dart';
import 'package:nasa_flutter/infra/datasources/local_image_datasource.dart';
import 'package:nasa_flutter/infra/models/nasa_image_model.dart';

class LocalImageDatasourceImpl implements LocalImageDatasource {
  final Box storage;

  LocalImageDatasourceImpl({required this.storage});

  static const String imagesStorageKey = 'images_key';

  @override
  Future<List<NasaImage>> getImages() async {
    final images = storage.get(imagesStorageKey) as List<Map<String, dynamic>>;

    // Parse list map to model
    return images.map((image) => NasaImageModel.fromMap(image)).toList();
  }

  @override
  Future<void> saveImages(List<NasaImage> images) async {
    List<NasaImageModel>? savedImages;

    try {
      // Get saved images
      savedImages = (await getImages())
          .map(
            (image) => NasaImageModel.fromEntity(image),
          )
          .toList();
    } catch (e) {
      debugPrint(e.toString());
    }

    // Parse params images to model
    final parsedImages = images
        .map(
          (image) => NasaImageModel.fromEntity(image),
        )
        .toList();

    List<NasaImageModel>? imagesToSave;

    if (savedImages != null) {
      imagesToSave = savedImages;
      // Add params images in list without duplicate items
      imagesToSave.addUniqueItems(parsedImages);
    } else {
      imagesToSave = parsedImages;
    }

    // Save images
    return storage.put(
      imagesStorageKey,
      imagesToSave.map((e) => e.toMap()).toList(),
    );
  }
}
