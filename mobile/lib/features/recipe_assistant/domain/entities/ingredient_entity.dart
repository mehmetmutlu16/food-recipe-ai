import 'package:equatable/equatable.dart';

/// Represents a single recognized ingredient.
class IngredientEntity extends Equatable {
  final String name;
  final String? normalizedName;

  const IngredientEntity({
    required this.name,
    this.normalizedName,
  });

  @override
  List<Object?> get props => [name, normalizedName];

  @override
  String toString() => 'IngredientEntity(name: $name)';
}
