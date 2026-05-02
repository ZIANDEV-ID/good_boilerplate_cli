import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.imageUrl,
    this.borderRadius = BorderRadius.zero,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String imageUrl;
  final BorderRadius borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        placeholder: (context, url) => const ColoredBox(
          color: Color(0xFFE2E8F0),
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
        errorWidget: (context, url, error) => const ColoredBox(
          color: Color(0xFFE2E8F0),
          child: Icon(Icons.image_not_supported_outlined),
        ),
      ),
    );
  }
}
