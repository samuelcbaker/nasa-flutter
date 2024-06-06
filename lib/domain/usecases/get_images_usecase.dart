import 'package:nasa_flutter/domain/entities/nasa_image.dart';
import 'package:nasa_flutter/domain/repositories/image_repository.dart';
import 'package:nasa_flutter/extensions/date_extension.dart';

class GetImagesUsecase {
  final ImageRepository repository;

  GetImagesUsecase({required this.repository});

  Future<List<NasaImage>> call(GetImagesParams params) async {
    // Pagination by date
    final now = DateTime.now().onlyDate();

    // End date is calculated with page number.
    // If page is 1, the number of days to subtract to actual date is 0. ((1 - 1) * 5) = 0.
    // If page is 2, the number of days to subtract to actual date is 5. ((2 - 1) * 5) = 5.
    // etc
    final endDate =
        now.subtract(Duration(days: (params.page - 1) * params.numberOfItems));

    // Start date is calculated by end date - number of items on page.
    // The decrement is because the end date is the first item.
    final startDate =
        endDate.subtract(Duration(days: params.numberOfItems - 1));

    // Call repository to search images
    final images = await repository.getImages(startDate, endDate);

    // Desc sort images by date
    images.sort((a, b) => b.date.compareTo(a.date));

    return images;
  }
}

class GetImagesParams {
  final int page;
  final int numberOfItems;

  GetImagesParams({this.page = 1, this.numberOfItems = 5});
}
