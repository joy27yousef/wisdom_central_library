import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wisdom_central_library/core/themes/app_colors.dart';

class AppCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final IconData fallbackIcon;
  final double fallbackIconSize;
  final Color? fallbackBackgroundColor;
  final Color? fallbackIconColor;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.fallbackIcon = Icons.book_rounded,
    this.fallbackIconSize = 36,
    this.fallbackBackgroundColor,
    this.fallbackIconColor,
  });

  @override
  Widget build(BuildContext context) {
    final cleanUrl = imageUrl?.trim() ?? '';

    return ClipRRect(
      borderRadius: borderRadius,
      child: cleanUrl.isEmpty
          ? _buildFallback()
          : CachedNetworkImage(
              imageUrl: cleanUrl,
              width: width,
              height: height,
              fit: fit,
              fadeInDuration: const Duration(milliseconds: 250),
              fadeOutDuration: const Duration(milliseconds: 150),
              // تحسين استهلاك الذاكرة بتحديد أبعاد الكاش حسب حجم العرض
              memCacheWidth: width != null && width!.isFinite
                  ? (width! * 2).toInt()
                  : null,
              placeholder: (context, url) => ShimmerBox(
                width: width ?? double.infinity,
                height: height ?? double.infinity,
                borderRadius: borderRadius,
              ),
              errorWidget: (context, url, error) => _buildFallback(),
            ),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      color: fallbackBackgroundColor ?? AppColors.prim.withValues(alpha: 0.08),
      alignment: Alignment.center,
      child: Icon(
        fallbackIcon,
        size: fallbackIconSize,
        color: fallbackIconColor ?? AppColors.prim,
      ),
    );
  }
}

class ShimmerBox extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final slide = (_controller.value * 2) - 0.5;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment(-1.0 + slide, -0.3),
              end: Alignment(1.0 + slide, 0.3),
              colors: const [
                Color(0xFFECEFF3),
                Color(0xFFF8FAFC),
                Color(0xFFECEFF3),
              ],
              stops: const [0.1, 0.5, 0.9],
            ),
          ),
        );
      },
    );
  }
}
