import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Full-screen loading overlay with animated indicator and message.
class LoadingOverlay extends StatelessWidget {
  final String message;

  const LoadingOverlay({
    super.key,
    this.message = 'Yükleniyor...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.85),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated cooking icon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (value * 0.2),
                  child: child,
                );
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.elevatedShadow,
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Loading indicator
            SizedBox(
              width: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(
                  backgroundColor: AppTheme.dividerColor,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Message
            Text(
              message,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
