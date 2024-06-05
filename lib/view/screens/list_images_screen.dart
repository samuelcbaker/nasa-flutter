import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_flutter/extensions/date_extension.dart';
import 'package:nasa_flutter/view/cubit/connectivity/connectivity_cubit.dart';
import 'package:nasa_flutter/view/cubit/connectivity/connectivity_state.dart';
import 'package:nasa_flutter/view/cubit/list_images/list_images_cubit.dart';
import 'package:nasa_flutter/view/cubit/list_images/list_images_state.dart';
import 'package:nasa_flutter/view/screens/image_detail_screen.dart';
import 'package:nasa_flutter/view/widgets/image_widget.dart';

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
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ImageDetailScreen(image: image),
                              ),
                            );
                          },
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
