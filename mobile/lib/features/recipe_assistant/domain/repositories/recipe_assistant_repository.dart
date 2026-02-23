import '../entities/ingredient_recognition_result_entity.dart';
import '../entities/recipe_input_type.dart';
import '../entities/recipe_entity.dart';

/// Abstract repository contract for the recipe assistant feature.
abstract class RecipeAssistantRepository {
  /// Sends an image to the backend for ingredient recognition.
  /// Returns recognized ingredients and optional backend request id.
  Future<IngredientRecognitionResultEntity> recognizeIngredientsFromImage(
      String imagePath);

  /// Sends a list of ingredient names to the backend
  /// and returns a generated recipe.
  Future<RecipeEntity> generateRecipe({
    required List<String> ingredients,
    required RecipeInputType inputType,
    String? requestId,
    String? rawText,
  });
}
