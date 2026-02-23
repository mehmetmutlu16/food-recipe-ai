class RequestHistoryRecipeIngredientDto {
  final String name;
  final double quantity;
  final String unit;

  const RequestHistoryRecipeIngredientDto({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory RequestHistoryRecipeIngredientDto.fromJson(Map<String, dynamic> json) {
    final quantityRaw = json['quantity'];
    final quantity = quantityRaw is num ? quantityRaw.toDouble() : 0.0;

    return RequestHistoryRecipeIngredientDto(
      name: (json['name'] ?? '').toString().trim(),
      quantity: quantity,
      unit: (json['unit'] ?? '').toString().trim(),
    );
  }

  String get displayText {
    final quantityText = quantity % 1 == 0 ? quantity.toInt().toString() : quantity.toString();
    if (name.isEmpty) {
      return '-';
    }
    if (quantity <= 0 && unit.isEmpty) {
      return name;
    }
    if (unit.isEmpty) {
      return '$quantityText $name';
    }
    return '$quantityText $unit $name';
  }
}

class RequestHistoryRecipeDto {
  final String id;
  final String? name;
  final int? prepTimeMinutes;
  final String? difficulty;
  final String? source;
  final List<RequestHistoryRecipeIngredientDto> ingredients;
  final List<String> steps;

  const RequestHistoryRecipeDto({
    required this.id,
    this.name,
    this.prepTimeMinutes,
    this.difficulty,
    this.source,
    required this.ingredients,
    required this.steps,
  });

  factory RequestHistoryRecipeDto.fromJson(Map<String, dynamic> json) {
    final ingredientsRaw = json['ingredients'];
    final ingredients = ingredientsRaw is List
        ? ingredientsRaw
            .whereType<Map>()
            .map(
              (item) => RequestHistoryRecipeIngredientDto.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList(growable: false)
        : const <RequestHistoryRecipeIngredientDto>[];

    final stepsRaw = json['steps'];
    final steps = stepsRaw is List
        ? stepsRaw.map((item) => item.toString()).toList(growable: false)
        : const <String>[];

    return RequestHistoryRecipeDto(
      id: (json['id'] ?? '').toString(),
      name: json['name'] as String?,
      prepTimeMinutes: json['prepTimeMinutes'] is num
          ? (json['prepTimeMinutes'] as num).toInt()
          : null,
      difficulty: json['difficulty'] as String?,
      source: json['source'] as String?,
      ingredients: ingredients,
      steps: steps,
    );
  }
}

class RequestHistoryItemDto {
  final String id;
  final String? createdAt;
  final String? inputType;
  final String? rawIngredientsText;
  final List<String> recognizedIngredients;
  final String? status;
  final String? errorCode;
  final RequestHistoryRecipeDto? recipe;

  const RequestHistoryItemDto({
    required this.id,
    this.createdAt,
    this.inputType,
    this.rawIngredientsText,
    required this.recognizedIngredients,
    this.status,
    this.errorCode,
    this.recipe,
  });

  factory RequestHistoryItemDto.fromJson(Map<String, dynamic> json) {
    final ingredientsRaw = json['recognizedIngredients'];
    final ingredients = ingredientsRaw is List
        ? ingredientsRaw.map((item) => item.toString()).toList(growable: false)
        : const <String>[];

    final recipeRaw = json['recipe'];
    return RequestHistoryItemDto(
      id: (json['id'] ?? '').toString(),
      createdAt: json['createdAt'] as String?,
      inputType: json['inputType'] as String?,
      rawIngredientsText: json['rawIngredientsText'] as String?,
      recognizedIngredients: ingredients,
      status: json['status'] as String?,
      errorCode: json['errorCode'] as String?,
      recipe: recipeRaw is Map<String, dynamic>
          ? RequestHistoryRecipeDto.fromJson(recipeRaw)
          : null,
    );
  }
}
