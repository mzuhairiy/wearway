import 'package:flutter/material.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';

/// Kotak skeleton loading sederhana (tanpa shimmer package) — dipakai sebagai
/// placeholder konsisten saat data async belum siap.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    this.width,
    this.height,
    this.radius = AppRadius.sm,
    super.key,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Skeleton kartu produk (thumbnail + 2 baris teks) untuk grid/list produk.
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: SkeletonBox()),
        SizedBox(height: AppSpacing.sm),
        SkeletonBox(height: 12, width: 120),
        SizedBox(height: AppSpacing.xs),
        SkeletonBox(height: 12, width: 70),
      ],
    );
  }
}
