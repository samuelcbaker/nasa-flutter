import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_flutter/domain/usecases/get_images_usecase.dart';
import 'package:nasa_flutter/view/cubit/list_images/list_images_state.dart';

class ListImagesCubit extends Cubit<ListImagesState> {
  final GetImagesUsecase getImagesUsecase;

  ListImagesCubit({required this.getImagesUsecase}) : super(InitialState()) {
    getImages();
  }

  // To feedback user and controll pagination
  bool isOffline = false;

  void setIsOffline(bool value) {
    isOffline = value;
  }

  void getImages() async {
    try {
      emit(LoadingState());
      final images = await getImagesUsecase(GetImagesParams(page: 1));
      // throw Exception();
      emit(LoadedState(images));
    } catch (e) {
      emit(ErrorState());
    }
  }
}
