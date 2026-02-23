import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/request_history_item_dto.dart';

class RequestHistoryPresenter {
  static String? recipeTitle(RequestHistoryItemDto item) {
    final recipeName = (item.recipe?.name ?? '').trim();
    if (recipeName.isEmpty) {
      return null;
    }
    return recipeName;
  }

  static String cardSubtitle(RequestHistoryItemDto item) {
    final dateText = formatDate(item.createdAt);
    final ingredientCount = item.recognizedIngredients.length;
    return '$dateText - $ingredientCount malzeme';
  }

  static Color statusColor(String? status) {
    if (status == 'success') {
      return AppTheme.successColor;
    }
    if (status == 'failed') {
      return AppTheme.errorColor;
    }
    return AppTheme.textHint;
  }

  static String statusLabel(String? status) {
    if (status == 'success') {
      return 'Tarif olusturuldu';
    }
    if (status == 'failed') {
      return 'Istek tamamlanamadi';
    }
    return 'Durum bilinmiyor';
  }

  static String difficultyLabel(String? difficulty) {
    switch (difficulty) {
      case 'easy':
        return 'Kolay';
      case 'medium':
        return 'Orta';
      case 'hard':
        return 'Zor';
      default:
        return '-';
    }
  }

  static String formatRecipeIngredients(
    List<RequestHistoryRecipeIngredientDto> ingredients,
  ) {
    if (ingredients.isEmpty) {
      return '-';
    }

    return ingredients
        .where((item) => item.name.trim().isNotEmpty)
        .map((item) => item.displayText)
        .join('\n');
  }

  static String formatSteps(List<String> steps) {
    final cleaned = steps
        .map((step) => step.trim())
        .where((step) => step.isNotEmpty)
        .toList(growable: false);

    if (cleaned.isEmpty) {
      return '-';
    }

    return cleaned
        .asMap()
        .entries
        .map((entry) => '${entry.key + 1}. ${entry.value}')
        .join('\n');
  }

  static String formatDate(String? iso) {
    if (iso == null || iso.trim().isEmpty) {
      return '-';
    }

    final date = DateTime.tryParse(iso);
    if (date == null) {
      return '-';
    }

    final local = date.toLocal();
    return '${local.year}-${_two(local.month)}-${_two(local.day)} '
        '${_two(local.hour)}:${_two(local.minute)}';
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}
