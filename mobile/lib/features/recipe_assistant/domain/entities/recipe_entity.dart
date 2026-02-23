import 'package:equatable/equatable.dart';
import 'recipe_ingredient_entity.dart';

/// Difficulty levels for a recipe.
enum RecipeDifficulty { easy, medium, hard }

/// Core recipe entity returned by the AI.
class RecipeEntity extends Equatable {
  final String name;
  final List<RecipeIngredientEntity> ingredients;
  final List<String> steps;
  final int prepTimeMinutes;
  final RecipeDifficulty difficulty;

  const RecipeEntity({
    required this.name,
    required this.ingredients,
    required this.steps,
    required this.prepTimeMinutes,
    required this.difficulty,
  });

  /// Turkish display label for difficulty.
  String get difficultyLabel {
    switch (difficulty) {
      case RecipeDifficulty.easy:
        return 'Kolay';
      case RecipeDifficulty.medium:
        return 'Orta';
      case RecipeDifficulty.hard:
        return 'Zor';
    }
  }

  /// Formatted prep time, e.g. "45 dk"
  String get prepTimeDisplay => '$prepTimeMinutes dk';

  @override
  List<Object?> get props =>
      [name, ingredients, steps, prepTimeMinutes, difficulty];
}
