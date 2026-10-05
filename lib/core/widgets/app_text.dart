import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum AppTextVariant { headline, title, body, caption, label, link }

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.body,
    this.style,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : textSpan = null;

  const AppText.headline(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight = FontWeight.w700,
    this.fontSize,
    this.height,
    this.letterSpacing = -0.6,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  })  : variant = AppTextVariant.headline,
        textSpan = null;

  const AppText.title(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight = FontWeight.w600,
    this.fontSize,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  })  : variant = AppTextVariant.title,
        textSpan = null;

  const AppText.body(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  })  : variant = AppTextVariant.body,
        textSpan = null;

  const AppText.caption(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.fontSize = 13,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  })  : variant = AppTextVariant.caption,
        textSpan = null;

  const AppText.label(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight = FontWeight.w600,
    this.fontSize,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  })  : variant = AppTextVariant.label,
        textSpan = null;

  const AppText.link(
    this.text, {
    super.key,
    this.style,
    this.color = AppTheme.mint,
    this.fontWeight = FontWeight.w700,
    this.fontSize,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  })  : variant = AppTextVariant.link,
        textSpan = null;

  const AppText.rich(
    InlineSpan this.textSpan, {
    super.key,
    this.variant = AppTextVariant.body,
    this.style,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : text = '';

  final String text;
  final InlineSpan? textSpan;
  final AppTextVariant variant;
  final TextStyle? style;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? height;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

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

    final effectiveStyle = (style != null ? base?.merge(style) ?? style : base)?.copyWith(
      color: color ?? style?.color,
      fontWeight: fontWeight ?? style?.fontWeight,
      fontSize: fontSize ?? style?.fontSize,
      height: height ?? style?.height,
      letterSpacing: letterSpacing ?? style?.letterSpacing,
    );

    if (textSpan != null) {
      return Text.rich(
        textSpan!,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        style: effectiveStyle,
      );
    }

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      style: effectiveStyle,
    );
  }
}
