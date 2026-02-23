import 'package:equatable/equatable.dart';

/// Base event class for the Recipe Assistant BLoC.
abstract class RecipeAssistantEvent extends Equatable {
  const RecipeAssistantEvent();

  @override
  List<Object?> get props => [];
}

/// User typed or changed ingredient text.
class IngredientsTextChanged extends RecipeAssistantEvent {
  final String text;

  const IngredientsTextChanged(this.text);

  @override
  List<Object?> get props => [text];
}

/// User picked an image from camera/gallery.
class ImagePicked extends RecipeAssistantEvent {
  final String path;

  const ImagePicked(this.path);

  @override
  List<Object?> get props => [path];
}

/// User cleared the selected image.
class ImageCleared extends RecipeAssistantEvent {
  const ImageCleared();
}

/// User tapped "Recognize Ingredients" button.
class RecognizeIngredientsRequested extends RecipeAssistantEvent {
  const RecognizeIngredientsRequested();
}

/// User removed a recognized ingredient chip.
class IngredientRemoved extends RecipeAssistantEvent {
  final String name;

  const IngredientRemoved(this.name);

  @override
  List<Object?> get props => [name];
}

/// User manually added an ingredient.
class ManualIngredientAdded extends RecipeAssistantEvent {
  final String name;

  const ManualIngredientAdded(this.name);

  @override
  List<Object?> get props => [name];
}

/// User tapped "Generate Recipe" button.
class GenerateRecipeRequested extends RecipeAssistantEvent {
  final String rawText;

  const GenerateRecipeRequested(this.rawText);

  @override
  List<Object?> get props => [rawText];
}

/// User tapped retry on error screen.
class RetryPressed extends RecipeAssistantEvent {
  const RetryPressed();
}

/// User wants to start over with a fresh flow.
class ResetFlow extends RecipeAssistantEvent {
  const ResetFlow();
}
