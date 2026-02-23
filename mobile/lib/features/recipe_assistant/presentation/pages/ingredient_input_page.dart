import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/recipe_assistant_bloc.dart';
import '../bloc/recipe_assistant_event.dart';
import '../bloc/recipe_assistant_state.dart';
import '../widgets/ingredient_input/ingredient_action_buttons.dart';
import '../widgets/ingredient_input/ingredient_header_card.dart';
import '../widgets/ingredient_input/ingredient_image_section.dart';
import '../widgets/ingredient_input/ingredient_input_app_bar.dart';
import '../widgets/ingredient_input/ingredient_text_input_section.dart';
import '../widgets/ingredient_input/manual_ingredient_input_section.dart';
import '../widgets/ingredient_input/recognized_ingredients_section.dart';
import '../widgets/loading_overlay.dart';
import 'request_history_page.dart';
import 'recipe_result_page.dart';

class IngredientInputPage extends StatefulWidget {
  const IngredientInputPage({super.key});

  @override
  State<IngredientInputPage> createState() => _IngredientInputPageState();
}

class _IngredientInputPageState extends State<IngredientInputPage> {
  final _textController = TextEditingController();
  final _manualIngredientController = TextEditingController();
  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    _textController.dispose();
    _manualIngredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecipeAssistantBloc, RecipeAssistantState>(
      listener: _onStateChanged,
      builder: (context, state) {
        final bloc = context.read<RecipeAssistantBloc>();

        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  IngredientInputAppBar(
                    onResetFlow: _resetFlow,
                    onOpenHistory: _openHistory,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const IngredientHeaderCard(),
                        const SizedBox(height: 24),
                        IngredientImageSection(
                          hasImage: state.hasImage,
                          imagePath: state.selectedImagePath,
                          onPickCamera: () => _pickImage(context, ImageSource.camera),
                          onPickGallery: () => _pickImage(context, ImageSource.gallery),
                          onClearImage: () {
                            bloc.add(const ImageCleared());
                          },
                        ),
                        const SizedBox(height: 20),
                        IngredientTextInputSection(
                          controller: _textController,
                        ),
                        const SizedBox(height: 20),
                        if (state.recognizedIngredients.isNotEmpty) ...[
                          RecognizedIngredientsSection(
                            ingredients: state.recognizedIngredients,
                            onRemove: (name) {
                              bloc.add(IngredientRemoved(name));
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                        ManualIngredientInputSection(
                          controller: _manualIngredientController,
                          onAdd: (name) => _addManualIngredient(name),
                        ),
                        const SizedBox(height: 32),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _textController,
                          builder: (_, textValue, __) {
                            final hasIngredients =
                                textValue.text.trim().isNotEmpty ||
                                    state.recognizedIngredients.isNotEmpty;

                            return IngredientActionButtons(
                              hasImage: state.hasImage,
                              isLoading: state.isLoading,
                              hasIngredients: hasIngredients,
                              onRecognizePressed: () {
                                bloc.add(const RecognizeIngredientsRequested());
                              },
                              onGeneratePressed: () {
                                bloc.add(
                                  GenerateRecipeRequested(textValue.text),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                      ]),
                    ),
                  ),
                ],
              ),
              if (state.isLoading)
                LoadingOverlay(
                  message: state.status == RecipeAssistantStatus.loadingRecognition
                      ? 'Malzemeler taniniyor...'
                      : 'Tarif hazirlaniyor...',
                ),
            ],
          ),
        );
      },
    );
  }

  void _onStateChanged(BuildContext context, RecipeAssistantState state) {
    if (state.status == RecipeAssistantStatus.success && state.recipe != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<RecipeAssistantBloc>(),
            child: const RecipeResultPage(),
          ),
        ),
      );
    }

    if (state.status == RecipeAssistantStatus.failure &&
        state.errorMessage != null) {
      _showFailureSnackBar(context, state.errorMessage!);
    }
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 900,
        maxHeight: 900,
        imageQuality: 75,
      );

      if (pickedFile != null && context.mounted) {
        context.read<RecipeAssistantBloc>().add(ImagePicked(pickedFile.path));
      }
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fotograf secilirken bir hata olustu.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _addManualIngredient(String name) {
    if (name.trim().isEmpty) {
      return;
    }

    context.read<RecipeAssistantBloc>().add(ManualIngredientAdded(name));
    _manualIngredientController.clear();
  }

  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RequestHistoryPage(),
      ),
    );
  }

  void _resetFlow() {
    FocusScope.of(context).unfocus();
    _textController.clear();
    _manualIngredientController.clear();
    context.read<RecipeAssistantBloc>().add(const ResetFlow());
  }

  void _showFailureSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          action: SnackBarAction(
            label: 'Tekrar Dene',
            textColor: Colors.white,
            onPressed: () {
              context.read<RecipeAssistantBloc>().add(const RetryPressed());
            },
          ),
        ),
      );
  }
}
