import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum AppTextVariant { headline, title, body, caption, label, link }

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.body,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  const AppText.headline(
    this.text, {
    super.key,
    this.color,
    this.fontWeight = FontWeight.w700,
    this.fontSize,
    this.height,
    this.letterSpacing = -0.6,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : variant = AppTextVariant.headline;

  const AppText.title(
    this.text, {
    super.key,
    this.color,
    this.fontWeight = FontWeight.w600,
    this.fontSize,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : variant = AppTextVariant.title;

  const AppText.body(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : variant = AppTextVariant.body;

  const AppText.caption(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize = 13,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : variant = AppTextVariant.caption;

  const AppText.label(
    this.text, {
    super.key,
    this.color,
    this.fontWeight = FontWeight.w600,
    this.fontSize,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : variant = AppTextVariant.label;

  const AppText.link(
    this.text, {
    super.key,
    this.color = AppTheme.mint,
    this.fontWeight = FontWeight.w700,
    this.fontSize,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : variant = AppTextVariant.link;

  final String text;
  final AppTextVariant variant;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? height;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final base = switch (variant) {
      AppTextVariant.headline => theme.headlineMedium,
      AppTextVariant.title => theme.titleLarge,
      AppTextVariant.body => theme.bodyLarge,
      AppTextVariant.caption => theme.bodySmall,
      AppTextVariant.label => theme.labelLarge,
      AppTextVariant.link => theme.bodyMedium,
    };

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base?.copyWith(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
