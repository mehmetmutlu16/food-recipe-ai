import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Preview card showing the selected image with a clear button.
class ImagePreviewCard extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClear;

  const ImagePreviewCard({
    super.key,
    required this.imagePath,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Stack(
          children: [
            // Image
            Image.file(
              File(imagePath),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: double.infinity,
                height: 200,
                color: AppTheme.shimmerBase,
                child: const Center(
                  child: Icon(
                    Icons.broken_image_rounded,
                    size: 48,
                    color: AppTheme.textHint,
                  ),
                ),
              ),
            ),

            // Gradient overlay at top for clear button visibility
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Clear button
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onClear,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ),
            ),

            // "Selected" badge
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Fotoğraf Seçildi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
