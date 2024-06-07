import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_flutter/domain/entities/nasa_image.dart';
import 'package:nasa_flutter/domain/usecases/get_images_usecase.dart';
import 'package:nasa_flutter/extensions/date_extension.dart';
import 'package:nasa_flutter/extensions/list_extension.dart';
import 'package:nasa_flutter/view/cubit/list_images/list_images_state.dart';

class ListImagesCubit extends Cubit<ListImagesState> {
  final GetImagesUsecase getImagesUsecase;

  ListImagesCubit({required this.getImagesUsecase}) : super(InitialState()) {
    getImages();
    _listenScrollController();
  }

  // Variables to control pagination
  final ScrollController scrollController = ScrollController();
  int actualPage = 1;
  List<NasaImage> listImages = [];

  // Variable to control search bar
  final TextEditingController searchEditingController = TextEditingController();

  // To feedback user and controll pagination
  bool _isOffline = false;
  void setIsOffline(bool value) {
    _isOffline = value;
  }

  void getImages() async {
    try {
      emit(actualPage == 1
          ? LoadingState()
          : LoadingAnotherPageState(listImages));
      final images = await getImagesUsecase(GetImagesParams(page: actualPage));
      listImages.addUniqueItems(images);
      emit(LoadedState(listImages));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void _resetList() {
    actualPage = 1;
    listImages = [];
    searchEditingController.clear();
  }

  void reload() {
    _resetList();
    getImages();
  }

  void getNextPage() {
    if (!_isOffline && state is LoadedState) {
      actualPage++;
      getImages();
    }
  }

  void _listenScrollController() {
    // Setup the listener.
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (!isTop) {
          getNextPage();
        }
      }
    });
  }

  void onChangedSearchBar(String str) {
    if (str.isEmpty) {
      emit(LoadedState(listImages));
      return;
    }

    final filteredList = listImages
        .where((image) =>
            // Filter by title and date
            '${image.title.toLowerCase()}${image.date.format()}'
                .contains(str.toLowerCase()))
        .toList();
    emit(FilteredImagesState(filteredList));
  }
}
