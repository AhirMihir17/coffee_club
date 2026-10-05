import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? fallbackColor;
  final IconData fallbackIcon;

  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.fallbackColor,
    this.fallbackIcon = Icons.coffee_rounded,
  });

  bool get _isNetwork =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBgColor = fallbackColor ??
        (isDark ? const Color(0xFF261D17) : const Color(0xFFF3ECE6));

    Widget imageWidget;

    if (_isNetwork) {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            placeholder ??
            Container(
              width: width,
              height: height,
              color: defaultBgColor,
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryCoffee.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            _buildDefaultFallback(defaultBgColor, isDark),
      );
    } else {
      imageWidget = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ??
            _buildDefaultFallback(defaultBgColor, isDark),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildDefaultFallback(Color bgColor, bool isDark) {
    return Container(
      width: width,
      height: height,
      color: bgColor,
      child: Center(
        child: Icon(
          fallbackIcon,
          size: (height != null && height! < 50) ? 20 : 36,
          color: AppTheme.primaryCoffee.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
