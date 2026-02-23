import 'package:dio/dio.dart';

import '../../../../core/error/app_failure.dart';
import '../../domain/entities/ingredient_recognition_result_entity.dart';
import '../../domain/entities/recipe_input_type.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repositories/recipe_assistant_repository.dart';
import '../datasources/recipe_api_service.dart';

class RecipeAssistantRepositoryImpl implements RecipeAssistantRepository {
  final RecipeApiService _apiService;

  RecipeAssistantRepositoryImpl(this._apiService);

  @override
  Future<IngredientRecognitionResultEntity> recognizeIngredientsFromImage(
    String imagePath,
  ) async {
    try {
      final dto = await _apiService.recognizeIngredients(imagePath);
      return dto.toEntity();
    } on DioException catch (e) {
      throw _mapDioError(e);
    } on FormatException catch (e) {
      throw AppFailure.validation(e.message.toString());
    } catch (_) {
      throw AppFailure.imageProcessing();
    }
  }

  @override
  Future<RecipeEntity> generateRecipe({
    required List<String> ingredients,
    required RecipeInputType inputType,
    String? requestId,
    String? rawText,
  }) async {
    try {
      final dto = await _apiService.generateRecipe(
        ingredients: ingredients,
        inputType: inputType.value,
        requestId: requestId,
        rawText: rawText,
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw _mapDioError(e);
    } on FormatException catch (e) {
      throw AppFailure.validation(e.message.toString());
    } catch (_) {
      throw AppFailure.unknown();
    }
  }

  AppFailure _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return AppFailure.network();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final message = _extractApiErrorMessage(e.response?.data);

        if (statusCode == 400) {
          return AppFailure.validation(
            message ?? 'Gecersiz istek gonderildi.',
          );
        }
        if (statusCode == 422) {
          return AppFailure.aiProcessing();
        }
        if (statusCode >= 500) {
          return AppFailure.server(message);
        }
        return AppFailure.server(message);
      default:
        return AppFailure.unknown();
    }
  }

  String? _extractApiErrorMessage(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) {
      return null;
    }

    final errorNode = responseData['error'];
    if (errorNode is Map<String, dynamic> && errorNode['message'] is String) {
      return errorNode['message'] as String;
    }

    final messageNode = responseData['message'];
    if (messageNode is String) {
      return messageNode;
    }

    return null;
  }
}
