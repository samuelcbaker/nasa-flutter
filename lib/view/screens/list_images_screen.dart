import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_flutter/domain/entities/nasa_image.dart';
import 'package:nasa_flutter/extensions/date_extension.dart';
import 'package:nasa_flutter/view/cubit/connectivity/connectivity_cubit.dart';
import 'package:nasa_flutter/view/cubit/connectivity/connectivity_state.dart';
import 'package:nasa_flutter/view/cubit/list_images/list_images_cubit.dart';
import 'package:nasa_flutter/view/cubit/list_images/list_images_state.dart';
import 'package:nasa_flutter/view/screens/image_detail_screen.dart';
import 'package:nasa_flutter/view/widgets/image_widget.dart';
import 'package:nasa_flutter/view/widgets/search_bar_widget.dart';

class ListImagesScreen extends StatelessWidget {
  const ListImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NASA\'s Astronomy POD'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async {
          context.read<ListImagesCubit>().reload();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SearchBarWidget(
                hint: 'Search images',
                onChanged: context.read<ListImagesCubit>().onChangedSearchBar,
                controller:
                    context.read<ListImagesCubit>().searchEditingController,
              ),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<ConnectivityCubit, ConnectivityState>(
                  builder: (context, state) {
                if (state is OfflineState) {
                  context.read<ListImagesCubit>().setIsOffline(true);
                  return const Column(
                    children: [
                      Text('You are offline :('),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  );
                }

                context.read<ListImagesCubit>().setIsOffline(false);
                return const SizedBox.shrink();
              }),
              Expanded(
                child: BlocBuilder<ListImagesCubit, ListImagesState>(
                    builder: (context, state) {
                  if (state is LoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Ops, an error occurred',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                context.read<ListImagesCubit>().getImages();
                              },
                              child: const Text('Reload'))
                        ],
                      ),
                    );
                  } else if (state is LoadedState) {
                    return _ListImagesWidget(
                      images: state.images,
                    );
                  } else if (state is LoadingAnotherPageState) {
                    return _ListImagesWidget(
                      images: state.loadedImages,
                    );
                  } else if (state is FilteredImagesState) {
                    return _ListImagesWidget(
                      images: state.images,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<ListImagesCubit, ListImagesState>(
                  builder: (context, state) {
                if (state is LoadingAnotherPageState) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      )),
    );
  }
}

class _ListImagesWidget extends StatelessWidget {
  final List<NasaImage> images;

  const _ListImagesWidget({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const Text(
        'No images found',
        style: TextStyle(
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      );
    }

    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      controller: context.read<ListImagesCubit>().scrollController,
      itemCount: images.length,
      separatorBuilder: (ctx, index) {
        return const SizedBox(
          height: 16,
        );
      },
      itemBuilder: (ctx, index) {
        final image = images[index];
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImageDetailScreen(image: image),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: Colors.blue.withOpacity(0.1),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    image.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ImageWidget(
                    url: image.url,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Date: ${image.date.format()}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
