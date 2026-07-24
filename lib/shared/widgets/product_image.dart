import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Gambar produk terpusat dengan strategi **hybrid** (Prompt 8 polish):
///
/// 1. `assets/...` → [Image.asset]. Kalau file belum ada →
/// 2. fallback ke foto network deterministic (picsum by nama file). Kalau
///    gagal juga →
/// 3. placeholder (ikon kaos).
///
/// `http...` langsung network. Selalu punya `semanticLabel` (aksesibilitas).
class ProductImage extends StatelessWidget {
  const ProductImage({
    required this.imageUrl,
    required this.semanticLabel,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String imageUrl;
  final String semanticLabel;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return _Placeholder(semanticLabel: semanticLabel);

    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: fit,
        semanticLabel: semanticLabel,
        // File asset belum ada → coba foto network (bukan placeholder).
        errorBuilder: (context, _, _) => _network(_picsumFor(imageUrl)),
      );
    }

    return _network(imageUrl);
  }

  /// Gambar network + placeholder/error konsisten.
  Widget _network(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      imageBuilder: (context, provider) =>
          Image(image: provider, fit: fit, semanticLabel: semanticLabel),
      placeholder: (context, _) => ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      errorWidget: (context, _, _) =>
          _Placeholder(semanticLabel: semanticLabel),
    );
  }

  /// URL picsum deterministic dari nama file asset (mis.
  /// `assets/products/prod_x.jpg` → seed `prod_x`) — tiap produk foto beda tapi
  /// stabil antar-run.
  static String _picsumFor(String assetPath) {
    final file = assetPath.split('/').last;
    final seed = file.contains('.') ? file.split('.').first : file;
    return 'https://picsum.photos/seed/$seed/600/600';
  }
}

/// Placeholder abu + ikon kaos saat gambar tak tersedia.
class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.semanticLabel});

  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: semanticLabel,
      image: true,
      child: ColoredBox(
        color: theme.colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            LucideIcons.shirt,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
