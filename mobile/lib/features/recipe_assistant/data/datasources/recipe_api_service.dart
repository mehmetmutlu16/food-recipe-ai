import 'dart:convert';
import 'dart:io';

import '../../../../core/network/dio_client.dart';
import '../models/ingredient_recognition_result_dto.dart';
import '../models/request_history_item_dto.dart';
import '../models/recipe_dto.dart';

class RecipeApiService {
  static const int _maxImageBytes = 4 * 1024 * 1024;

  final DioClient _client;

  RecipeApiService(this._client);

  Future<IngredientRecognitionResultDto> recognizeIngredients(
    String imagePath,
  ) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) {
      throw const FormatException('Secilen fotograf okunamadi.');
    }
    if (bytes.lengthInBytes > _maxImageBytes) {
      throw const FormatException(
        'Fotograf cok buyuk. Lutfen daha kucuk bir gorsel secin.',
      );
    }

    final base64Image = base64Encode(bytes);

    final response = await _client.post(
      '/ingredients/recognize',
      data: {
        'image': base64Image,
        'mimeType': _getMimeType(imagePath),
      },
    );

    final data = response.data as Map<String, dynamic>;
    return IngredientRecognitionResultDto.fromJson(data);
  }

  Future<RecipeDto> generateRecipe({
    required List<String> ingredients,
    required String inputType,
    String? requestId,
    String? rawText,
  }) async {
    final response = await _client.post(
      '/recipes/generate',
      data: {
        'ingredients': ingredients,
        'inputType': inputType,
        if (requestId != null && requestId.trim().isNotEmpty) 'requestId': requestId,
        if (rawText != null && rawText.trim().isNotEmpty) 'notes': rawText,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final recipeData = data['recipe'];
    if (recipeData is Map<String, dynamic>) {
      return RecipeDto.fromJson(recipeData);
    }

    throw const FormatException('Recipe payload missing in API response.');
  }

  Future<List<RequestHistoryItemDto>> getRequestHistory({
    int limit = 50,
    String? status,
    String? inputType,
    bool includeRecipe = true,
  }) async {
    final response = await _client.get(
      '/requests/history',
      queryParameters: {
        'limit': limit,
        if (status != null) 'status': status,
        if (inputType != null) 'inputType': inputType,
        'includeRecipe': includeRecipe,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final rawItems = data['requests'];
    if (rawItems is! List) {
      return const [];
    }

    return rawItems
        .whereType<Map>()
        .map((item) => RequestHistoryItemDto.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList(growable: false);
  }

  String _getMimeType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      default:
        return 'image/jpeg';
    }
  }
}
