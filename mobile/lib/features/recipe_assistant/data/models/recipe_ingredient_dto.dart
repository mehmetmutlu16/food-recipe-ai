import '../../domain/entities/recipe_ingredient_entity.dart';

/// Data Transfer Object for a recipe ingredient (with quantity & unit).
class RecipeIngredientDto {
  final String name;
  final double quantity;
  final String unit;

  const RecipeIngredientDto({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory RecipeIngredientDto.fromJson(Map<String, dynamic> json) {
    return RecipeIngredientDto(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'unit': unit,
      };

  /// Maps to domain entity.
  RecipeIngredientEntity toEntity() {
    return RecipeIngredientEntity(
      name: name,
      quantity: quantity,
      unit: unit,
    );
  }
}
