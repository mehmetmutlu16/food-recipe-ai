import '../entities/recipe_input_type.dart';
import '../entities/recipe_entity.dart';
import '../repositories/recipe_assistant_repository.dart';

/// Use case: Generate a recipe from a list of ingredients.
class GenerateRecipeUseCase {
  final RecipeAssistantRepository _repository;

  GenerateRecipeUseCase(this._repository);

  /// Execute the use case.
  /// [ingredients] is the list of ingredient names.
  /// [rawText] is optional raw text input from the user.
  Future<RecipeEntity> call({
    required List<String> ingredients,
    required RecipeInputType inputType,
    String? requestId,
    String? rawText,
  }) {
    return _repository.generateRecipe(
      ingredients: ingredients,
      inputType: inputType,
      requestId: requestId,
      rawText: rawText,
    );
  }
}
