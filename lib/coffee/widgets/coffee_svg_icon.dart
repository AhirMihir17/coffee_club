import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoffeeSvgIcon extends StatelessWidget {
  final String assetName;
  final double size;
  final Color? color;
  final IconData? fallbackIcon;

  const CoffeeSvgIcon({
    super.key,
    required this.assetName,
    this.size = 22,
    this.color,
    this.fallbackIcon,
  });

  String get _fullPath {
    if (assetName.startsWith('assets/')) {
      return assetName;
    }
    return 'assets/svg/$assetName.svg';
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _fullPath,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      placeholderBuilder: (context) => Icon(
        fallbackIcon ?? Icons.coffee_rounded,
        size: size,
        color: color,
      ),
    );
  }
}
