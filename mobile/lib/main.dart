import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/network/dio_client.dart';
import 'core/theme/app_theme.dart';
import 'features/recipe_assistant/data/datasources/recipe_api_service.dart';
import 'features/recipe_assistant/data/repositories/recipe_assistant_repository_impl.dart';
import 'features/recipe_assistant/domain/usecases/generate_recipe_usecase.dart';
import 'features/recipe_assistant/domain/usecases/recognize_ingredients_usecase.dart';
import 'features/recipe_assistant/presentation/bloc/recipe_assistant_bloc.dart';
import 'features/recipe_assistant/presentation/pages/ingredient_input_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RecipeAssistantApp(dependencies: RecipeAssistantDependencies.create()));
}

class RecipeAssistantDependencies {
  final RecognizeIngredientsUseCase recognizeIngredientsUseCase;
  final GenerateRecipeUseCase generateRecipeUseCase;

  const RecipeAssistantDependencies({
    required this.recognizeIngredientsUseCase,
    required this.generateRecipeUseCase,
  });

  factory RecipeAssistantDependencies.create() {
    final dioClient = DioClient();
    final apiService = RecipeApiService(dioClient);
    final repository = RecipeAssistantRepositoryImpl(apiService);

    return RecipeAssistantDependencies(
      recognizeIngredientsUseCase: RecognizeIngredientsUseCase(repository),
      generateRecipeUseCase: GenerateRecipeUseCase(repository),
    );
  }
}

class RecipeAssistantApp extends StatelessWidget {
  final RecipeAssistantDependencies dependencies;

  const RecipeAssistantApp({
    super.key,
    required this.dependencies,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecipeAssistantBloc(
        recognizeIngredients: dependencies.recognizeIngredientsUseCase,
        generateRecipe: dependencies.generateRecipeUseCase,
      ),
      child: MaterialApp(
        title: 'Tarif Asistani',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        locale: const Locale('tr', 'TR'),
        supportedLocales: const [
          Locale('tr', 'TR'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const IngredientInputPage(),
      ),
    );
  }
}
