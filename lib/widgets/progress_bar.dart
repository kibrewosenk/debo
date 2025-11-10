import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progress; // 0.0 .. 1.0
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;

  const ProgressBar({
    super.key,
    required this.progress,
    this.height = 10.0,
    this.backgroundColor,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey.shade200,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final barWidth = constraints.maxWidth * progress.clamp(0.0, 1.0);

            return Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  width: barWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        progressColor ?? const Color(0xFF00ADEF),
                        progressColor?.withOpacity(0.8) ??
                            const Color(0xFF00ADEF).withOpacity(0.8),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
