import 'package:flutter/material.dart';

class ListImagesScreen extends StatelessWidget {
  const ListImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NASA\'s Astronomy POD'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: ListView.separated(
            itemBuilder: (ctx, index) {
              return InkWell(
                onTap: () {},
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
                        const Text(
                          'Comet Pons-Brooks Develops Opposing Tails',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        _ImageWidget(
                          url: index % 2 == 0
                              ? 'https://apod.nasa.gov/apod/image/2406/N00172886_92_beltramini.jpg'
                              : 'https://apod.nasa.gov/apod/image/2405/NGC2403-LRGB+Ha+Oiii-v25-f1024.jpg',
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          'Date: 2024-01-01',
                          style: TextStyle(fontSize: 16),
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
            separatorBuilder: (ctx, index) {
              return const SizedBox(
                height: 16,
              );
            },
            itemCount: 5),
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
