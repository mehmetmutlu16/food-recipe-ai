import '../../domain/entities/ingredient_recognition_result_entity.dart';
import 'ingredient_dto.dart';

class IngredientRecognitionResultDto {
  final List<IngredientDto> ingredients;
  final String? requestId;

  const IngredientRecognitionResultDto({
    required this.ingredients,
    required this.requestId,
  });

  factory IngredientRecognitionResultDto.fromJson(Map<String, dynamic> json) {
    final rawItems = json['recognizedIngredients'];
    final items = rawItems is List
        ? rawItems
            .map((item) => IngredientDto.fromString(item.toString()))
            .toList(growable: false)
        : const <IngredientDto>[];

    final requestIdRaw = json['requestId'];
    final requestId =
        requestIdRaw is String && requestIdRaw.trim().isNotEmpty
            ? requestIdRaw.trim()
            : null;

    return IngredientRecognitionResultDto(
      ingredients: items,
      requestId: requestId,
    );
  }

  IngredientRecognitionResultEntity toEntity() {
    return IngredientRecognitionResultEntity(
      ingredients: ingredients.map((dto) => dto.toEntity()).toList(growable: false),
      requestId: requestId,
    );
  }
}
