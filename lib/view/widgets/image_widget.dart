import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String url;
  const ImageWidget({super.key, required this.url});

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
