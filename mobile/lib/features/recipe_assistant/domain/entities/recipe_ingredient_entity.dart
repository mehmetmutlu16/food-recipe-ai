import 'package:equatable/equatable.dart';

/// Represents one ingredient line in a recipe (with quantity and unit).
class RecipeIngredientEntity extends Equatable {
  final String name;
  final double quantity;
  final String unit;

  const RecipeIngredientEntity({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  /// Human-readable display string, e.g. "2 adet Domates"
  String get displayText {
    final qtyStr =
        quantity == quantity.roundToDouble() ? quantity.toInt().toString() : quantity.toString();
    return '$qtyStr $unit $name';
  }

  @override
  List<Object?> get props => [name, quantity, unit];
}
