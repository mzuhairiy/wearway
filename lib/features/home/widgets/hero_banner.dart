import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// URL banner network deterministic (landscape) dari nama file asset.
String _picsumFor(String assetPath) {
  final file = assetPath.split('/').last;
  final seed = file.contains('.') ? file.split('.').first : file;
  return 'https://picsum.photos/seed/$seed/1200/600';
}

/// Satu slide promo: gambar banner (asset) atau gradient fallback + teks.
class _Slide {
  const _Slide({
    required this.asset,
    required this.title,
    required this.subtitle,
  });

  final String asset;
  final String title;
  final String subtitle;
}

const List<_Slide> _slides = [
  _Slide(
    asset: 'assets/banners/banner_1.jpg',
    title: 'Gaya Baru,\nCara Baru.',
    subtitle: 'Koleksi fashion ramah lingkungan WearWay.',
  ),
  _Slide(
    asset: 'assets/banners/banner_2.jpg',
    title: 'Diskon s.d. 10%',
    subtitle: 'Pakai kode WEARWAY10 di keranjang.',
  ),
  _Slide(
    asset: 'assets/banners/banner_3.jpg',
    title: 'Gratis Ongkir',
    subtitle: 'Untuk belanja di atas Rp 300rb.',
  ),
];

/// Hero banner berputar (auto-play + swipe) di Home.
/// StatefulWidget dibenarkan di sini: butuh PageController + Timer auto-play.
class HeroBanner extends StatefulWidget {
  const HeroBanner({super.key});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  final _controller = PageController();
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    // Auto-advance tiap 5 detik (loop).
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_controller.hasClients) return;
      final next = (_page + 1) % _slides.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey(TestKeys.heroBanner),
      padding: AppSpacing.pagePadding,
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: PageView.builder(
              controller: _controller,
              itemCount: _slides.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) => _BannerSlide(slide: _slides[i]),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < _slides.length; i++) _Dot(active: i == _page),
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerSlide extends StatelessWidget {
  const _BannerSlide({required this.slide});

  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient sebagai dasar (juga fallback terakhir).
          DecoratedBox(decoration: BoxDecoration(gradient: gradient)),
          // Banner asset → kalau belum ada, fallback foto network
          // deterministic; kalau gagal juga, gradient di bawah tetap tampil.
          Image.asset(
            slide.asset,
            fit: BoxFit.cover,
            semanticLabel: slide.title.replaceAll('\n', ' '),
            errorBuilder: (context, _, _) => CachedNetworkImage(
              imageUrl: _picsumFor(slide.asset),
              fit: BoxFit.cover,
              placeholder: (context, _) => const SizedBox.shrink(),
              errorWidget: (context, _, _) => const SizedBox.shrink(),
            ),
          ),
          // Scrim gelap supaya teks terbaca di atas gambar apa pun.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black45, Colors.transparent],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slide.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  slide.subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: active ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    );
  }
}
