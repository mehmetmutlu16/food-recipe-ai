import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../image_preview_card.dart';
import '../section_title.dart';

class IngredientImageSection extends StatelessWidget {
  final bool hasImage;
  final String? imagePath;
  final VoidCallback onPickCamera;
  final VoidCallback onPickGallery;
  final VoidCallback onClearImage;

  const IngredientImageSection({
    super.key,
    required this.hasImage,
    required this.imagePath,
    required this.onPickCamera,
    required this.onPickGallery,
    required this.onClearImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Fotograf ile Malzeme Algilama',
          icon: Icons.camera_alt_rounded,
        ),
        const SizedBox(height: 10),
        if (hasImage && imagePath != null)
          ImagePreviewCard(
            imagePath: imagePath!,
            onClear: onClearImage,
          )
        else
          Row(
            children: [
              Expanded(
                child: _PickerButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Kamera',
                  onTap: onPickCamera,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PickerButton(
                  icon: Icons.photo_library_rounded,
                  label: 'Galeri',
                  onTap: onPickGallery,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _PickerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: AppTheme.dividerColor,
            ),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: AppTheme.primaryColor),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
