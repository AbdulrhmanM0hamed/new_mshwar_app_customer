import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:new_mshwar_app_customer/core/theme/colors.dart';
import 'package:new_mshwar_app_customer/core/theme/spacing.dart';

/// ─────────────────────────────────────────────────────────────
/// Generic shimmer list for loading skeletons.
/// ─────────────────────────────────────────────────────────────
class ShimmerList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry? padding;
  final bool isSliver;

  const ShimmerList({
    super.key,
    this.itemCount = 6,
    this.itemHeight = 80,
    this.padding,
    this.isSliver = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shimmer = Shimmer.fromColors(
      baseColor: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
      highlightColor: isDark
          ? AppColors.shimmerHighlightDark
          : AppColors.shimmerHighlight,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding:
            padding ??
            const EdgeInsets.symmetric(
              horizontal: Spacing.screenH,
              vertical: Spacing.sm,
            ),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: Spacing.sm),
        itemBuilder: (_, __) => _ShimmerItem(height: itemHeight),
      ),
    );

    if (isSliver) {
      return SliverToBoxAdapter(child: shimmer);
    }
    return shimmer;
  }
}

class _ShimmerItem extends StatelessWidget {
  final double height;
  const _ShimmerItem({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
      ),
    );
  }
}

/// Single shimmer box — useful inside custom layouts.
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
      highlightColor: isDark
          ? AppColors.shimmerHighlightDark
          : AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
