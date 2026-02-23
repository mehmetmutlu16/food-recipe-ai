import '../../domain/entities/ingredient_entity.dart';

/// Data Transfer Object for an ingredient from the API.
class IngredientDto {
  final String name;
  final String? normalizedName;

  const IngredientDto({
    required this.name,
    this.normalizedName,
  });

  factory IngredientDto.fromJson(Map<String, dynamic> json) {
    return IngredientDto(
      name: json['name'] as String,
      normalizedName: json['normalizedName'] as String?,
    );
  }

  /// Convert from a plain string (when API returns just names).
  factory IngredientDto.fromString(String name) {
    return IngredientDto(name: name);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        if (normalizedName != null) 'normalizedName': normalizedName,
      };

  /// Maps to domain entity.
  IngredientEntity toEntity() {
    return IngredientEntity(
      name: name,
      normalizedName: normalizedName,
    );
  }
}
