import 'package:equatable/equatable.dart';

import '../../domain/entities/ingredient_entity.dart';
import '../../domain/entities/recipe_input_type.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/services/ingredient_name_service.dart';

/// Flow status enum for the recipe assistant.
enum RecipeAssistantStatus {
  initial,
  editing,
  loadingRecognition,
  loadingRecipe,
  success,
  failure,
}

/// Immutable state for the Recipe Assistant BLoC.
class RecipeAssistantState extends Equatable {
  final RecipeAssistantStatus status;
  final String ingredientsText;
  final String? selectedImagePath;
  final String? lastRecognitionRequestId;
  final List<IngredientEntity> recognizedIngredients;
  final RecipeEntity? recipe;
  final String? errorMessage;

  const RecipeAssistantState({
    this.status = RecipeAssistantStatus.initial,
    this.ingredientsText = '',
    this.selectedImagePath,
    this.lastRecognitionRequestId,
    this.recognizedIngredients = const [],
    this.recipe,
    this.errorMessage,
  });

  /// Whether we have any ingredients (text or recognized).
  bool get hasIngredients =>
      ingredientsText.trim().isNotEmpty || recognizedIngredients.isNotEmpty;

  /// Combined ingredient names for recipe generation.
  List<String> get allIngredientNames {
    final textItems = IngredientNameService.parseFreeText(ingredientsText);
    final recognizedItems = recognizedIngredients.map((item) => item.name);
    return IngredientNameService.uniquePreserveOrder([
      ...recognizedItems,
      ...textItems,
    ]);
  }

  /// Whether an image is selected.
  bool get hasImage => selectedImagePath != null;

  RecipeInputType get inputType {
    final hasText = ingredientsText.trim().isNotEmpty;
    if (hasText && hasImage) {
      return RecipeInputType.mixed;
    }
    if (hasImage) {
      return RecipeInputType.image;
    }
    return RecipeInputType.text;
  }

  /// Whether the flow is in a loading state.
  bool get isLoading =>
      status == RecipeAssistantStatus.loadingRecognition ||
      status == RecipeAssistantStatus.loadingRecipe;

  /// Copy with pattern for immutable updates.
  RecipeAssistantState copyWith({
    RecipeAssistantStatus? status,
    String? ingredientsText,
    String? Function()? selectedImagePath,
    String? Function()? lastRecognitionRequestId,
    List<IngredientEntity>? recognizedIngredients,
    RecipeEntity? Function()? recipe,
    String? Function()? errorMessage,
  }) {
    return RecipeAssistantState(
      status: status ?? this.status,
      ingredientsText: ingredientsText ?? this.ingredientsText,
      selectedImagePath: selectedImagePath != null
          ? selectedImagePath()
          : this.selectedImagePath,
      lastRecognitionRequestId: lastRecognitionRequestId != null
          ? lastRecognitionRequestId()
          : this.lastRecognitionRequestId,
      recognizedIngredients:
          recognizedIngredients ?? this.recognizedIngredients,
      recipe: recipe != null ? recipe() : this.recipe,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        ingredientsText,
        selectedImagePath,
        lastRecognitionRequestId,
        recognizedIngredients,
        recipe,
        errorMessage,
      ];
}
