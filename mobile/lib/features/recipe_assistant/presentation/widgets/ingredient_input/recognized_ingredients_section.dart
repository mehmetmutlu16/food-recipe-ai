import 'package:flutter/material.dart';

import '../../../domain/entities/ingredient_entity.dart';
import '../../../../../core/theme/app_theme.dart';
import '../ingredient_chip.dart';
import '../section_title.dart';

class RecognizedIngredientsSection extends StatelessWidget {
  final List<IngredientEntity> ingredients;
  final ValueChanged<String> onRemove;

  const RecognizedIngredientsSection({
    super.key,
    required this.ingredients,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: 'Taninan Malzemeler (${ingredients.length})',
          icon: Icons.check_circle_rounded,
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ingredients
                .map(
                  (ingredient) => IngredientChip(
                    name: ingredient.name,
                    onRemove: () => onRemove(ingredient.name),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}
