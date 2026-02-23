import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_assistant/features/recipe_assistant/domain/entities/ingredient_entity.dart';
import 'package:recipe_assistant/features/recipe_assistant/domain/entities/recipe_entity.dart';
import 'package:recipe_assistant/features/recipe_assistant/domain/entities/recipe_input_type.dart';
import 'package:recipe_assistant/features/recipe_assistant/domain/repositories/recipe_assistant_repository.dart';
import 'package:recipe_assistant/features/recipe_assistant/domain/usecases/generate_recipe_usecase.dart';
import 'package:recipe_assistant/features/recipe_assistant/domain/usecases/recognize_ingredients_usecase.dart';
import 'package:recipe_assistant/main.dart';

void main() {
  testWidgets('app renders ingredient input screen', (WidgetTester tester) async {
    final repository = _FakeRecipeAssistantRepository();
    final dependencies = RecipeAssistantDependencies(
      recognizeIngredientsUseCase: RecognizeIngredientsUseCase(repository),
      generateRecipeUseCase: GenerateRecipeUseCase(repository),
    );

    await tester.pump();
    await tester.pumpWidget(
      RecipeAssistantApp(dependencies: dependencies),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tarif Asistani'), findsOneWidget);
  });
}

class _FakeRecipeAssistantRepository implements RecipeAssistantRepository {
  @override
  Future<RecipeEntity> generateRecipe({
    required List<String> ingredients,
    required RecipeInputType inputType,
    String? rawText,
  }) async {
    return const RecipeEntity(
      name: 'Test Tarif',
      ingredients: [],
      steps: ['Adim 1'],
      prepTimeMinutes: 10,
      difficulty: RecipeDifficulty.easy,
    );
  }

  @override
  Future<List<IngredientEntity>> recognizeIngredientsFromImage(
    String imagePath,
  ) async {
    return const [];
  }
}
