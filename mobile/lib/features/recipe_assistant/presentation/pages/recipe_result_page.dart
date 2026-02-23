import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/recipe_assistant_bloc.dart';
import '../bloc/recipe_assistant_event.dart';
import '../bloc/recipe_assistant_state.dart';
import '../widgets/primary_gradient_button.dart';
import '../widgets/recipe_result/recipe_ingredients_section.dart';
import '../widgets/recipe_result/recipe_quick_info_row.dart';
import '../widgets/recipe_result/recipe_result_hero_app_bar.dart';
import '../widgets/recipe_result/recipe_steps_section.dart';

class RecipeResultPage extends StatelessWidget {
  const RecipeResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeAssistantBloc, RecipeAssistantState>(
      builder: (context, state) {
        final recipe = state.recipe;
        if (recipe == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Tarif')),
            body: const Center(child: Text('Tarif bulunamadi.')),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          body: CustomScrollView(
            slivers: [
              RecipeResultHeroAppBar(
                recipe: recipe,
                onBackPressed: () => Navigator.of(context).pop(),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    RecipeQuickInfoRow(recipe: recipe),
                    const SizedBox(height: 24),
                    RecipeIngredientsSection(recipe: recipe),
                    const SizedBox(height: 24),
                    RecipeStepsSection(recipe: recipe),
                    const SizedBox(height: 32),
                    PrimaryGradientButton(
                      icon: Icons.add_rounded,
                      label: 'Yeni Tarif Uret',
                      onPressed: () {
                        context.read<RecipeAssistantBloc>().add(const ResetFlow());
                        Navigator.of(context).pop();
                      },
                      gradient: const LinearGradient(
                        colors: [AppTheme.primaryColor, AppTheme.primaryDark],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
