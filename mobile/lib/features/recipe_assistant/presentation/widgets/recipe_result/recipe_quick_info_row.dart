import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/recipe_entity.dart';

class RecipeQuickInfoRow extends StatelessWidget {
  final RecipeEntity recipe;

  const RecipeQuickInfoRow({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoChip(
            icon: Icons.timer_rounded,
            label: recipe.prepTimeDisplay,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _InfoChip(
            icon: Icons.signal_cellular_alt_rounded,
            label: recipe.difficultyLabel,
            color: _difficultyColor(recipe.difficulty),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _InfoChip(
            icon: Icons.shopping_basket_rounded,
            label: '${recipe.ingredients.length} Malzeme',
            color: AppTheme.accentColor,
          ),
        ),
      ],
    );
  }

  Color _difficultyColor(RecipeDifficulty difficulty) {
    switch (difficulty) {
      case RecipeDifficulty.easy:
        return AppTheme.easyColor;
      case RecipeDifficulty.medium:
        return AppTheme.mediumColor;
      case RecipeDifficulty.hard:
        return AppTheme.hardColor;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
