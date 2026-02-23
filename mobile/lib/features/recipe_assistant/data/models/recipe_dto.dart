import '../../domain/entities/recipe_entity.dart';
import 'recipe_ingredient_dto.dart';

/// Data Transfer Object for the full recipe response from the API.
class RecipeDto {
  final String name;
  final List<RecipeIngredientDto> ingredients;
  final List<String> steps;
  final int prepTimeMinutes;
  final String difficulty;

  const RecipeDto({
    required this.name,
    required this.ingredients,
    required this.steps,
    required this.prepTimeMinutes,
    required this.difficulty,
  });

  factory RecipeDto.fromJson(Map<String, dynamic> json) {
    return RecipeDto(
      name: json['name'] as String,
      ingredients: (json['ingredients'] as List)
          .map((e) => RecipeIngredientDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      steps: (json['steps'] as List).map((e) => e as String).toList(),
      prepTimeMinutes: json['prepTimeMinutes'] as int,
      difficulty: json['difficulty'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'ingredients': ingredients.map((e) => e.toJson()).toList(),
        'steps': steps,
        'prepTimeMinutes': prepTimeMinutes,
        'difficulty': difficulty,
      };

  /// Maps to domain entity.
  RecipeEntity toEntity() {
    return RecipeEntity(
      name: name,
      ingredients: ingredients.map((e) => e.toEntity()).toList(),
      steps: steps,
      prepTimeMinutes: prepTimeMinutes,
      difficulty: _parseDifficulty(difficulty),
    );
  }

  static RecipeDifficulty _parseDifficulty(String value) {
    switch (value.toLowerCase()) {
      case 'easy':
        return RecipeDifficulty.easy;
      case 'medium':
        return RecipeDifficulty.medium;
      case 'hard':
        return RecipeDifficulty.hard;
      default:
        return RecipeDifficulty.medium;
    }
  }
}
