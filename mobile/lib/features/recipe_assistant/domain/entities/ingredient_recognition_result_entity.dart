import 'ingredient_entity.dart';

class IngredientRecognitionResultEntity {
  final List<IngredientEntity> ingredients;
  final String? requestId;

  const IngredientRecognitionResultEntity({
    required this.ingredients,
    required this.requestId,
  });
}
