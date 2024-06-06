import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_flutter/domain/entities/nasa_image.dart';
import 'package:nasa_flutter/domain/usecases/get_images_usecase.dart';
import 'package:nasa_flutter/view/cubit/list_images/list_images_cubit.dart';
import 'package:nasa_flutter/view/cubit/list_images/list_images_state.dart';

class GetImagesUsecaseMock extends Mock implements GetImagesUsecase {}

void main() {
  late GetImagesUsecase usecase;
  late ListImagesCubit cubit;

  final imagesMock = [
    NasaImage(
      title: 'title',
      explanation: 'explanation',
      url: 'url',
      date: DateTime.now(),
    ),
  ];

  setUp(() {
    registerFallbackValue(GetImagesParams(page: 1));
    usecase = GetImagesUsecaseMock();
    cubit = ListImagesCubit(getImagesUsecase: usecase);
  });

  blocTest<ListImagesCubit, ListImagesState>(
    'should emit loaded state',
    build: () => cubit,
    act: (_) {
      when(
        () => usecase(any()),
      ).thenAnswer((_) async => imagesMock);

      cubit.getImages();
    },
    expect: () => [LoadingState(), LoadedState(imagesMock)],
  );

  blocTest<ListImagesCubit, ListImagesState>(
    'should emit error state',
    build: () => cubit,
    act: (_) {
      when(
        () => usecase(any()),
      ).thenThrow(Exception());

      cubit.getImages();
    },
    expect: () => [LoadingState(), ErrorState()],
  );

  blocTest<ListImagesCubit, ListImagesState>(
    'should reset list and emit loaded state',
    build: () => cubit,
    act: (_) {
      when(
        () => usecase(any()),
      ).thenAnswer((_) async => imagesMock);

      cubit.reload();
    },
    expect: () => [LoadingState(), LoadedState(imagesMock)],
  );

  group('pagination', () {
    blocTest<ListImagesCubit, ListImagesState>(
      'should get another page',
      build: () => cubit,
      seed: () => LoadedState(const []),
      act: (_) {
        when(
          () => usecase(any()),
        ).thenAnswer((_) async => imagesMock);

        cubit.getNextPage();
      },
      expect: () =>
          [LoadingAnotherPageState(imagesMock), LoadedState(imagesMock)],
    );

    blocTest<ListImagesCubit, ListImagesState>(
      'shouldnt get another page if page is loading',
      build: () => cubit,
      seed: () => LoadingState(),
      act: (_) {
        when(
          () => usecase(any()),
        ).thenAnswer((_) async => imagesMock);

        cubit.getNextPage();
      },
      expect: () => [],
    );

    blocTest<ListImagesCubit, ListImagesState>(
      'shouldnt get another page if page is error',
      build: () => cubit,
      seed: () => ErrorState(),
      act: (_) {
        when(
          () => usecase(any()),
        ).thenAnswer((_) async => imagesMock);

        cubit.getNextPage();
      },
      expect: () => [],
    );

    blocTest<ListImagesCubit, ListImagesState>(
      'shouldnt get another page if page is loading another page',
      build: () => cubit,
      seed: () => LoadingAnotherPageState(const []),
      act: (_) {
        when(
          () => usecase(any()),
        ).thenAnswer((_) async => imagesMock);

        cubit.getNextPage();
      },
      expect: () => [],
    );

    blocTest<ListImagesCubit, ListImagesState>(
      'shouldnt get another page if is offline',
      build: () => cubit,
      seed: () => LoadedState(const []),
      act: (_) {
        when(
          () => usecase(any()),
        ).thenAnswer((_) async => imagesMock);

        cubit.setIsOffline(true);
        cubit.getNextPage();
      },
      expect: () => [],
    );
  });
}
