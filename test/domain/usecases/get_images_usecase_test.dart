import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_flutter/domain/entities/nasa_image.dart';
import 'package:nasa_flutter/domain/repositories/image_repository.dart';
import 'package:nasa_flutter/domain/usecases/get_images_usecase.dart';
import 'package:nasa_flutter/extensions/date_extension.dart';

class ImageRepositoryMock extends Mock implements ImageRepository {}

void main() {
  late ImageRepository repository;
  late GetImagesUsecase usecase;

  setUp(() {
    repository = ImageRepositoryMock();
    usecase = GetImagesUsecase(repository: repository);
  });

  test('should call first page with today and 4 days ago', () async {
    when(
      () => repository.getImages(any(), any()),
    ).thenAnswer((_) async => [
          NasaImage(
              title: 'title',
              explanation: 'explanation',
              url: 'url',
              date: DateTime.now()),
          //...
        ]);

    final result = await usecase(GetImagesParams());

    expect(result[0], isA<NasaImage>());

    final now = DateTime.now().onlyDate();
    verify(() =>
            repository.getImages(now.subtract(const Duration(days: 4)), now))
        .called(1);
  });

  test('should call second page with 9 days ago', () async {
    when(
      () => repository.getImages(any(), any()),
    ).thenAnswer((_) async => [
          NasaImage(
              title: 'title',
              explanation: 'explanation',
              url: 'url',
              date: DateTime.now()),
          //...
        ]);

    final result = await usecase(GetImagesParams(page: 2));

    expect(result[0], isA<NasaImage>());

    final now = DateTime.now().onlyDate();
    verify(() => repository.getImages(now.subtract(const Duration(days: 9)),
        now.subtract(const Duration(days: 5)))).called(1);
  });
}
