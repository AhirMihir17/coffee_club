import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AuthCardShimmer extends StatelessWidget {
  final bool isDark;

  const AuthCardShimmer({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final baseColor = isDark
        ? const Color(0xFF261D18)
        : const Color(0xFFE8DDD4);
    final highlightColor = isDark
        ? const Color(0xFF3D2E24)
        : const Color(0xFFFAF4EE);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Input 1 skeleton
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 12),
          // Input 2 skeleton
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 12),
          // Option skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 110,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                width: 90,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Button skeleton
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthPerksShimmer extends StatelessWidget {
  final bool isDark;

  const AuthPerksShimmer({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final baseColor = isDark
        ? const Color(0xFF261D18)
        : const Color(0xFFE8DDD4);
    final highlightColor = isDark
        ? const Color(0xFF3D2E24)
        : const Color(0xFFFAF4EE);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }),
      ),
    );
  }
}
