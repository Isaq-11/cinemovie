import 'package:flutter/material.dart';

class PosterPreview extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double aspectRatio;
  final double borderRadius;
  final IconData placeholderIcon;
  final VoidCallback? onTap;

  const PosterPreview({
    super.key,
    required this.imageUrl,
    this.width = 120,
    this.aspectRatio = 2 / 3,
    this.borderRadius = 12,
    this.placeholderIcon = Icons.movie_creation_outlined,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final poster = SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: imageUrl == null || imageUrl!.isEmpty
              ? _buildPlaceholder(context)
              : Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return _buildLoading(context);
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder(context);
                  },
                ),
        ),
      ),
    );

    if (onTap == null) {
      return poster;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: poster,
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          placeholderIcon,
          size: 40,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
