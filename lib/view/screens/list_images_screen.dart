import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_flutter/extensions/date_extension.dart';
import 'package:nasa_flutter/view/cubit/connectivity/connectivity_cubit.dart';
import 'package:nasa_flutter/view/cubit/connectivity/connectivity_state.dart';
import 'package:nasa_flutter/view/cubit/list_images/list_images_cubit.dart';
import 'package:nasa_flutter/view/cubit/list_images/list_images_state.dart';

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
          context.read<ListImagesCubit>().getImages();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
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
                            'Ops, some error occours',
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
                    return ListView.separated(
                      itemCount: state.images.length,
                      separatorBuilder: (ctx, index) {
                        return const SizedBox(
                          height: 16,
                        );
                      },
                      itemBuilder: (ctx, index) {
                        final image = state.images[index];
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  _ImageWidget(
                                    url: image.url,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Date: ${image.date.format()}',
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class _ImageWidget extends StatelessWidget {
  final String url;
  const _ImageWidget({required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.fitHeight,
      height: 250,
      errorBuilder: (context, error, stackTrace) => const Text(
        '(Error on load image)',
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }
}
