import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../primary_gradient_button.dart';

class IngredientActionButtons extends StatelessWidget {
  final bool hasImage;
  final bool isLoading;
  final bool hasIngredients;
  final VoidCallback onRecognizePressed;
  final VoidCallback onGeneratePressed;

  const IngredientActionButtons({
    super.key,
    required this.hasImage,
    required this.isLoading,
    required this.hasIngredients,
    required this.onRecognizePressed,
    required this.onGeneratePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hasImage)
          PrimaryGradientButton(
            icon: Icons.search_rounded,
            label: 'Malzemeleri Algila',
            onPressed: isLoading ? null : onRecognizePressed,
            gradient: const LinearGradient(
              colors: [AppTheme.accentColor, Color(0xFF3DBAB2)],
            ),
          ),
        if (hasImage) const SizedBox(height: 12),
        PrimaryGradientButton(
          icon: Icons.auto_awesome_rounded,
          label: 'Tarif Uret',
          onPressed: isLoading || !hasIngredients ? null : onGeneratePressed,
          gradient: const LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.primaryDark],
          ),
        ),
      ],
    );
  }
}
