import '../entities/ingredient_recognition_result_entity.dart';
import '../repositories/recipe_assistant_repository.dart';

/// Use case: Recognize ingredients from a photo.
class RecognizeIngredientsUseCase {
  final RecipeAssistantRepository _repository;

  RecognizeIngredientsUseCase(this._repository);

  /// Execute the use case.
  /// [imagePath] is the local file path of the selected image.
  Future<IngredientRecognitionResultEntity> call(String imagePath) {
    return _repository.recognizeIngredientsFromImage(imagePath);
  }
}
