import 'package:nasa_flutter/domain/entities/nasa_image.dart';
import 'package:nasa_flutter/domain/repositories/image_repository.dart';

class GetImagesUsecase {
  final ImageRepository repository;

  GetImagesUsecase({required this.repository});

  Future<List<NasaImage>> call(GetImagesParams params) async {
    // Pagination by date
    final now = DateTime.now();

    // End date is calculated with page number.
    // If page is 1, the number of days to subtract to actual date is 0. ((1 - 1) * 5) = 0.
    // If page is 2, the number of days to subtract to actual date is 5. ((2 - 1) * 5) = 5.
    // If page is 3, the number of days to subtract to actual date is 10. ((3 - 1) * 5) = 10.
    // etc
    final endDate =
        now.subtract(Duration(days: (params.page - 1) * params.numberOfItems));

    // Start date is calculated end date - number of items on page.
    final startDate = endDate.subtract(Duration(days: params.numberOfItems));

    // Call repository to search images
    return repository.getImages(startDate, endDate);
  }
}

class GetImagesParams {
  final int page;
  final int numberOfItems;

  GetImagesParams({this.page = 1, this.numberOfItems = 5});
}
