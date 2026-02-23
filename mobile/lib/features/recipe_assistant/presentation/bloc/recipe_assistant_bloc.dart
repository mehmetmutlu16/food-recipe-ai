import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_failure.dart';
import '../../domain/entities/ingredient_entity.dart';
import '../../domain/entities/recipe_input_type.dart';
import '../../domain/services/ingredient_name_service.dart';
import '../../domain/usecases/generate_recipe_usecase.dart';
import '../../domain/usecases/recognize_ingredients_usecase.dart';
import 'recipe_assistant_event.dart';
import 'recipe_assistant_state.dart';

/// Main BLoC for the Recipe Assistant feature.
///
/// Handles the full flow: ingredient input -> recognition -> recipe generation.
class RecipeAssistantBloc
    extends Bloc<RecipeAssistantEvent, RecipeAssistantState> {
  final RecognizeIngredientsUseCase _recognizeIngredients;
  final GenerateRecipeUseCase _generateRecipe;

  RecipeAssistantBloc({
    required RecognizeIngredientsUseCase recognizeIngredients,
    required GenerateRecipeUseCase generateRecipe,
  })  : _recognizeIngredients = recognizeIngredients,
        _generateRecipe = generateRecipe,
        super(const RecipeAssistantState()) {
    on<IngredientsTextChanged>(_onIngredientsTextChanged);
    on<ImagePicked>(_onImagePicked);
    on<ImageCleared>(_onImageCleared);
    on<RecognizeIngredientsRequested>(_onRecognizeIngredientsRequested);
    on<IngredientRemoved>(_onIngredientRemoved);
    on<ManualIngredientAdded>(_onManualIngredientAdded);
    on<GenerateRecipeRequested>(_onGenerateRecipeRequested);
    on<RetryPressed>(_onRetryPressed);
    on<ResetFlow>(_onResetFlow);
  }

  void _onIngredientsTextChanged(
    IngredientsTextChanged event,
    Emitter<RecipeAssistantState> emit,
  ) {
    _emitEditing(
      emit,
      ingredientsText: event.text,
    );
  }

  void _onImagePicked(
    ImagePicked event,
    Emitter<RecipeAssistantState> emit,
  ) {
    _emitEditing(
      emit,
      selectedImagePath: () => event.path,
      lastRecognitionRequestId: () => null,
    );
  }

  void _onImageCleared(
    ImageCleared event,
    Emitter<RecipeAssistantState> emit,
  ) {
    _emitEditing(
      emit,
      selectedImagePath: () => null,
      lastRecognitionRequestId: () => null,
    );
  }

  Future<void> _onRecognizeIngredientsRequested(
    RecognizeIngredientsRequested event,
    Emitter<RecipeAssistantState> emit,
  ) async {
    if (!state.hasImage) {
      _emitFailure(emit, 'Lutfen once bir fotograf secin.');
      return;
    }

    emit(state.copyWith(
      status: RecipeAssistantStatus.loadingRecognition,
      errorMessage: () => null,
    ));

    try {
      final recognition = await _recognizeIngredients(state.selectedImagePath!);
      final merged = _mergeUniqueIngredients(
        state.recognizedIngredients,
        recognition.ingredients,
      );

      _emitEditing(
        emit,
        recognizedIngredients: merged,
        lastRecognitionRequestId: () => recognition.requestId,
      );
    } on AppFailure catch (e) {
      _emitFailure(emit, e.message);
    } catch (_) {
      _emitFailure(emit, AppFailure.unknown().message);
    }
  }

  void _onIngredientRemoved(
    IngredientRemoved event,
    Emitter<RecipeAssistantState> emit,
  ) {
    final targetKey = IngredientNameService.normalize(event.name);
    final updated = state.recognizedIngredients
        .where((item) => IngredientNameService.normalize(item.name) != targetKey)
        .toList(growable: false);

    _emitEditing(
      emit,
      recognizedIngredients: updated,
    );
  }

  void _onManualIngredientAdded(
    ManualIngredientAdded event,
    Emitter<RecipeAssistantState> emit,
  ) {
    final normalized = IngredientNameService.normalize(event.name);
    if (normalized.isEmpty) {
      return;
    }

    final exists = state.recognizedIngredients.any(
      (item) => IngredientNameService.normalize(item.name) == normalized,
    );
    if (exists) {
      return;
    }

    final updated = [
      ...state.recognizedIngredients,
      IngredientEntity(name: event.name.trim()),
    ];

    _emitEditing(
      emit,
      recognizedIngredients: updated,
    );
  }

  Future<void> _onGenerateRecipeRequested(
    GenerateRecipeRequested event,
    Emitter<RecipeAssistantState> emit,
  ) async {
    final rawText = event.rawText.trim();
    final textItems = IngredientNameService.parseFreeText(rawText);
    final recognizedItems = state.recognizedIngredients.map((item) => item.name);
    final ingredientNames = IngredientNameService.uniquePreserveOrder([
      ...recognizedItems,
      ...textItems,
    ]);

    if (ingredientNames.isEmpty) {
      _emitFailure(emit, 'Tarif uretmek icin en az bir malzeme girin.');
      return;
    }

    emit(state.copyWith(
      status: RecipeAssistantStatus.loadingRecipe,
      errorMessage: () => null,
    ));

    try {
      final recipe = await _generateRecipe(
        ingredients: ingredientNames,
        inputType: _resolveInputType(
          hasImage: state.hasImage,
          rawText: rawText,
        ),
        requestId: state.lastRecognitionRequestId,
        rawText: rawText.isEmpty ? null : rawText,
      );

      emit(state.copyWith(
        status: RecipeAssistantStatus.success,
        recipe: () => recipe,
        lastRecognitionRequestId: () => null,
      ));
    } on AppFailure catch (e) {
      _emitFailure(emit, e.message);
    } catch (_) {
      _emitFailure(emit, AppFailure.unknown().message);
    }
  }

  RecipeInputType _resolveInputType({
    required bool hasImage,
    required String rawText,
  }) {
    final hasText = rawText.trim().isNotEmpty;
    if (hasImage && hasText) {
      return RecipeInputType.mixed;
    }
    if (hasImage) {
      return RecipeInputType.image;
    }
    return RecipeInputType.text;
  }

  void _onRetryPressed(
    RetryPressed event,
    Emitter<RecipeAssistantState> emit,
  ) {
    _emitEditing(emit);
  }

  void _onResetFlow(
    ResetFlow event,
    Emitter<RecipeAssistantState> emit,
  ) {
    emit(const RecipeAssistantState());
  }

  void _emitFailure(
    Emitter<RecipeAssistantState> emit,
    String message,
  ) {
    emit(state.copyWith(
      status: RecipeAssistantStatus.failure,
      errorMessage: () => message,
    ));
  }

  void _emitEditing(
    Emitter<RecipeAssistantState> emit, {
    String? ingredientsText,
    String? Function()? selectedImagePath,
    String? Function()? lastRecognitionRequestId,
    List<IngredientEntity>? recognizedIngredients,
  }) {
    emit(state.copyWith(
      status: RecipeAssistantStatus.editing,
      ingredientsText: ingredientsText,
      selectedImagePath: selectedImagePath,
      lastRecognitionRequestId: lastRecognitionRequestId,
      recognizedIngredients: recognizedIngredients,
      errorMessage: () => null,
    ));
  }

  List<IngredientEntity> _mergeUniqueIngredients(
    List<IngredientEntity> current,
    List<IngredientEntity> incoming,
  ) {
    final map = <String, IngredientEntity>{};
    for (final item in [...current, ...incoming]) {
      final key = IngredientNameService.normalize(item.name);
      if (key.isEmpty || map.containsKey(key)) {
        continue;
      }

      map[key] = IngredientEntity(
        name: item.name.trim(),
        normalizedName: item.normalizedName,
      );
    }

    return map.values.toList(growable: false);
  }
}
