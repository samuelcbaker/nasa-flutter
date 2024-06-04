import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_flutter/domain/entities/nasa_image.dart';
import 'package:nasa_flutter/domain/exceptions/exceptions.dart';
import 'package:nasa_flutter/domain/repositories/image_repository.dart';
import 'package:nasa_flutter/infra/datasources/api_image_datasource.dart';
import 'package:nasa_flutter/infra/datasources/local_image_datasource.dart';
import 'package:nasa_flutter/infra/repositories/image_repository_impl.dart';

class ApiImageDatasourceMock extends Mock implements ApiImageDatasource {}

class LocalImageDatasourceMock extends Mock implements LocalImageDatasource {}

void main() {
  late ApiImageDatasource apiImageDatasource;
  late LocalImageDatasource localImageDatasource;
  late ImageRepository repository;
  final listImageMock = [
    NasaImage(
      title: 'title',
      explanation: 'explanation',
      url: 'url',
      date: DateTime.now(),
    ),
  ];

  setUp(() {
    apiImageDatasource = ApiImageDatasourceMock();
    localImageDatasource = LocalImageDatasourceMock();

    repository = ImageRepositoryImpl(
      apiImageDatasource: apiImageDatasource,
      localImageDatasource: localImageDatasource,
    );
  });

  test('should get images from api and save on local datasource', () async {
    when(
      () => apiImageDatasource.getImages(any(), any()),
    ).thenAnswer((_) async => listImageMock);

    when(
      () => localImageDatasource.saveImages(any()),
    ).thenAnswer((invocation) async {});

    final result = await repository.getImages(DateTime.now(), DateTime.now());

    expect(result[0], listImageMock[0]);
    verify(
      () => apiImageDatasource.getImages(any(), any()),
    ).called(1);
    verify(
      () => localImageDatasource.saveImages(any()),
    ).called(1);
    verifyNever(
      () => localImageDatasource.getImages(),
    );
  });

  test('should get images from api and but not throw error if local fails',
      () async {
    when(
      () => apiImageDatasource.getImages(any(), any()),
    ).thenAnswer((_) async => listImageMock);

    when(
      () => localImageDatasource.saveImages(any()),
    ).thenThrow(Exception());

    final result = await repository.getImages(DateTime.now(), DateTime.now());

    expect(result[0], listImageMock[0]);
    verify(
      () => apiImageDatasource.getImages(any(), any()),
    ).called(1);
  });

  test('should get images from local if api fails', () async {
    when(
      () => apiImageDatasource.getImages(any(), any()),
    ).thenThrow(Exception());

    when(
      () => localImageDatasource.getImages(),
    ).thenAnswer((invocation) async => listImageMock);

    final result = await repository.getImages(DateTime.now(), DateTime.now());

    expect(result[0], listImageMock[0]);
    verify(
      () => apiImageDatasource.getImages(any(), any()),
    ).called(1);
    verify(
      () => localImageDatasource.getImages(),
    ).called(1);
    verifyNever(
      () => localImageDatasource.saveImages(any()),
    );
  });

  test('should throw NotFoundItemsException if local and api fails', () async {
    when(
      () => apiImageDatasource.getImages(any(), any()),
    ).thenThrow(Exception());

    when(
      () => localImageDatasource.getImages(),
    ).thenThrow(Exception());

    expect(() => repository.getImages(DateTime.now(), DateTime.now()),
        throwsA(isA<NotFoundItemsException>()));
  });
}
