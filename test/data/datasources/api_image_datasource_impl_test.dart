import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_flutter/constants.dart';
import 'package:nasa_flutter/data/datasources/api_image_datasource_impl.dart';
import 'package:nasa_flutter/domain/exceptions/exceptions.dart';
import 'package:nasa_flutter/infra/datasources/api_image_datasource.dart';

import '../../mock/images_mock.dart';

class DioMock extends Mock implements Dio {}

void main() {
  late Dio dio;
  late ApiImageDatasource datasource;

  setUp(() {
    dio = DioMock();
    datasource = ApiImageDatasourceImpl(dio: dio);
  });

  test('should get images and parse correctly', () async {
    when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async {
      final response = imagesJsonMockWithoutVideo;

      return Response(requestOptions: RequestOptions(), data: response);
    });

    final response = await datasource.getImages(
      DateTime(2024, 2, 1),
      DateTime(2024, 2, 4),
    );

    expect(response.length, 3);
    expect(response[0].title, 'Stereo Helene');
    expect(response[0].explanation,
        "Get out your red/blue glasses and float next to Helene, small, icy moon of Saturn. Appropriately named, Helene is a Trojan moon, so called because it orbits at a Lagrange point. A Lagrange point is a gravitationally stable position near two massive bodies, in this case Saturn and larger moon Dione. In fact, irregularly shaped ( about 36 by 32 by 30 kilometers) Helene orbits at Dione's leading Lagrange point while brotherly ice moon Polydeuces follows at Dione's trailing Lagrange point. The sharp stereo anaglyph was constructed from two Cassini images captured during a close flyby in 2011. It shows part of the Saturn-facing hemisphere of Helene mottled with craters and gully-like features.");
    expect(response[0].url,
        'https://apod.nasa.gov/apod/image/2406/N00172886_92_beltramini.jpg');
    expect(response[0].date.year, 2024);
    expect(response[0].date.month, 6);
    expect(response[0].date.day, 1);

    verify(
      () => dio.get('/planetary/apod', queryParameters: {
        'api_key': nasaApiKey,
        'start_date': '2024-02-01',
        'end_date': '2024-02-04',
      }),
    ).called(1);
  });

  test('should get images and parse correctly and remove other media types',
      () async {
    when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async {
      final response = imagesJsonMockWithVideo;

      return Response(requestOptions: RequestOptions(), data: response);
    });

    final response = await datasource.getImages(
      DateTime(2024, 2, 1),
      DateTime(2024, 2, 4),
    );

    expect(response.length, 3);

    verify(
      () => dio.get('/planetary/apod', queryParameters: {
        'api_key': nasaApiKey,
        'start_date': '2024-02-01',
        'end_date': '2024-02-04',
      }),
    ).called(1);
  });

  test('should throw NetworkException if response is null', () {
    when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async {
      return Response(requestOptions: RequestOptions(), data: null);
    });

    expect(
        () => datasource.getImages(
              DateTime(2024, 2, 1),
              DateTime(2024, 2, 4),
            ),
        throwsA(isA<NetworkException>()));
  });

  test('should throw NetworkException if response is not a List', () {
    when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async {
      return Response(requestOptions: RequestOptions(), data: {});
    });

    expect(
        () => datasource.getImages(
              DateTime(2024, 2, 1),
              DateTime(2024, 2, 4),
            ),
        throwsA(isA<NetworkException>()));
  });
}
