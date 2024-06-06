import 'package:equatable/equatable.dart';
import 'package:nasa_flutter/domain/entities/nasa_image.dart';

abstract class ListImagesState extends Equatable {}

class InitialState extends ListImagesState {
  @override
  List<Object> get props => [];
}

class LoadingState extends ListImagesState {
  @override
  List<Object> get props => [];
}

class LoadingAnotherPageState extends ListImagesState {
  LoadingAnotherPageState(this.loadedImages);

  final List<NasaImage> loadedImages;

  @override
  List<Object> get props => [loadedImages];
}

class LoadedState extends ListImagesState {
  LoadedState(this.images);

  final List<NasaImage> images;

  @override
  List<Object> get props => [images];
}

class ErrorState extends ListImagesState {
  @override
  List<Object> get props => [];
}
