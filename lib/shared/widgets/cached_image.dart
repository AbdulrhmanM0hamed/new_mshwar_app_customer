import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────
/// Cached network image placeholder.
///
/// MIGRATION_TODO: Replace with cached_network_image package
/// when added to pubspec.
/// ─────────────────────────────────────────────────────────────
class CachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _fallback();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? _loadingPlaceholder();
        },
        errorBuilder: (_, __, ___) => errorWidget ?? _fallback(),
      ),
    );
  }

  Widget _loadingPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _fallback() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
    );
  }
}
