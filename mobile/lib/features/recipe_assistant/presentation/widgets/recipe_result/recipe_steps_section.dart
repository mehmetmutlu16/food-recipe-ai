import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/recipe_entity.dart';
import '../recipe_step_card.dart';

class RecipeStepsSection extends StatelessWidget {
  final RecipeEntity recipe;

  const RecipeStepsSection({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: const Icon(
                Icons.format_list_numbered_rounded,
                size: 18,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Hazirlanisi',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...List.generate(
          recipe.steps.length,
          (index) => RecipeStepCard(
            stepNumber: index + 1,
            instruction: recipe.steps[index],
          ),
        ),
      ],
    );
  }
}
