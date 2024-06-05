import 'package:flutter/material.dart';
import 'package:nasa_flutter/domain/entities/nasa_image.dart';
import 'package:nasa_flutter/extensions/date_extension.dart';
import 'package:nasa_flutter/view/widgets/image_widget.dart';

class ImageDetailScreen extends StatelessWidget {
  final NasaImage image;
  const ImageDetailScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          image.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ImageWidget(url: image.url),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Date: ${image.date.format()}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  image.explanation,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
