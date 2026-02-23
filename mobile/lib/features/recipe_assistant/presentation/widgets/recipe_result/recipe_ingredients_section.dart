import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/recipe_entity.dart';

class RecipeIngredientsSection extends StatelessWidget {
  final RecipeEntity recipe;

  const RecipeIngredientsSection({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _IngredientsHeader(),
          const SizedBox(height: 16),
          for (final ingredient in recipe.ingredients)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _IngredientRow(text: ingredient.displayText),
            ),
        ],
      ),
    );
  }
}

class _IngredientsHeader extends StatelessWidget {
  const _IngredientsHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
          child: const Icon(
            Icons.shopping_basket_rounded,
            size: 18,
            color: AppTheme.accentColor,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Malzemeler',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final String text;

  const _IngredientRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppTheme.accentColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textPrimary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
