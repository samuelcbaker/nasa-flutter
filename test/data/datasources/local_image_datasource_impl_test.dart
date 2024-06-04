import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_flutter/data/datasources/local_image_datasource_impl.dart';
import 'package:nasa_flutter/domain/entities/nasa_image.dart';
import 'package:nasa_flutter/infra/datasources/local_image_datasource.dart';

import '../../mock/images_mock.dart';

class BoxMock extends Mock implements Box {}

void main() {
  late Box storage;
  late LocalImageDatasource datasource;

  setUp(() {
    storage = BoxMock();
    datasource = LocalImageDatasourceImpl(storage: storage);
  });

  group('#getImages', () {
    test('should get images and parse correctly', () async {
      when(
        () => storage.get(any()),
      ).thenAnswer((_) => imagesJsonMock);

      final response = await datasource.getImages();

      expect(response.length, 4);
      expect(response[0].title, 'Stereo Helene');
      expect(response[0].explanation,
          "Get out your red/blue glasses and float next to Helene, small, icy moon of Saturn. Appropriately named, Helene is a Trojan moon, so called because it orbits at a Lagrange point. A Lagrange point is a gravitationally stable position near two massive bodies, in this case Saturn and larger moon Dione. In fact, irregularly shaped ( about 36 by 32 by 30 kilometers) Helene orbits at Dione's leading Lagrange point while brotherly ice moon Polydeuces follows at Dione's trailing Lagrange point. The sharp stereo anaglyph was constructed from two Cassini images captured during a close flyby in 2011. It shows part of the Saturn-facing hemisphere of Helene mottled with craters and gully-like features.");
      expect(response[0].url,
          'https://apod.nasa.gov/apod/image/2406/N00172886_92_beltramini.jpg');
      expect(response[0].date.year, 2024);
      expect(response[0].date.month, 6);
      expect(response[0].date.day, 1);
    });
  });

  group('#saveImages', () {
    test('should save only params images if storage is empty', () async {
      when(
        () => storage.get(any()),
      ).thenAnswer((invocation) => null);

      when(
        () => storage.put(any(), any()),
      ).thenAnswer((_) async {});

      final listMock = [
        NasaImage(
            title: 'title',
            explanation: 'explanation',
            url: 'url',
            date: DateTime(2024, 6, 4))
      ];

      await datasource.saveImages(listMock);

      verify(
        () => storage.put(LocalImageDatasourceImpl.imagesStorageKey, [
          {
            "title": 'title',
            "explanation": 'explanation',
            "url": 'url',
            "date": '2024-06-04',
          }
        ]),
      ).called(1);
    });

    test('should save params images plus old images if storage is not empty',
        () async {
      when(
        () => storage.get(any()),
      ).thenAnswer((invocation) => [
            {
              "title": 'title1',
              "explanation": 'explanation1',
              "url": 'url1',
              "date": '2024-06-05',
            }
          ]);

      when(
        () => storage.put(any(), any()),
      ).thenAnswer((_) async {});

      final listMock = [
        NasaImage(
            title: 'title',
            explanation: 'explanation',
            url: 'url',
            date: DateTime(2024, 6, 4))
      ];

      await datasource.saveImages(listMock);

      verify(
        () => storage.put(LocalImageDatasourceImpl.imagesStorageKey, [
          {
            "title": 'title1',
            "explanation": 'explanation1',
            "url": 'url1',
            "date": '2024-06-05',
          },
          {
            "title": 'title',
            "explanation": 'explanation',
            "url": 'url',
            "date": '2024-06-04',
          }
        ]),
      ).called(1);
    });

    test('should save duplicated params images', () async {
      when(
        () => storage.get(any()),
      ).thenAnswer((invocation) => [
            {
              "title": 'title',
              "explanation": 'explanation',
              "url": 'url',
              "date": '2024-06-04',
            }
          ]);

      when(
        () => storage.put(any(), any()),
      ).thenAnswer((_) async {});

      final listMock = [
        NasaImage(
            title: 'title',
            explanation: 'explanation',
            url: 'url',
            date: DateTime(2024, 6, 4))
      ];

      await datasource.saveImages(listMock);

      verify(
        () => storage.put(LocalImageDatasourceImpl.imagesStorageKey, [
          {
            "title": 'title',
            "explanation": 'explanation',
            "url": 'url',
            "date": '2024-06-04',
          }
        ]),
      ).called(1);
    });
  });
}
