import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/request_history_item_dto.dart';
import 'request_history_presenter.dart';

class RequestHistoryDetailSheet extends StatelessWidget {
  final RequestHistoryItemDto item;

  const RequestHistoryDetailSheet({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = RequestHistoryPresenter.statusColor(item.status);
    final statusLabel = RequestHistoryPresenter.statusLabel(item.status);
    final title = RequestHistoryPresenter.recipeTitle(item);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    RequestHistoryPresenter.formatDate(item.createdAt),
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (title != null) ...[
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
              ],
              _DetailLine(
                label: 'Bendeki malzemeler',
                value: item.recognizedIngredients.isEmpty
                    ? '-'
                    : item.recognizedIngredients.join(', '),
              ),
              if ((item.rawIngredientsText ?? '').trim().isNotEmpty)
                _DetailLine(
                  label: 'Yazili not',
                  value: item.rawIngredientsText!,
                ),
              if (item.recipe != null) ...[
                _DetailLine(
                  label: 'Tarifteki malzemeler',
                  value: RequestHistoryPresenter.formatRecipeIngredients(
                    item.recipe!.ingredients,
                  ),
                ),
                _DetailLine(
                  label: 'Hazirlama suresi',
                  value: '${item.recipe?.prepTimeMinutes ?? '-'} dk',
                ),
                _DetailLine(
                  label: 'Zorluk',
                  value: RequestHistoryPresenter.difficultyLabel(
                    item.recipe?.difficulty,
                  ),
                ),
                _DetailLine(
                  label: 'Adimlar',
                  value: RequestHistoryPresenter.formatSteps(item.recipe!.steps),
                ),
              ],
              if ((item.errorCode ?? '').trim().isNotEmpty)
                _DetailLine(
                  label: 'Teknik kod',
                  value: item.errorCode!,
                  valueColor: AppTheme.errorColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailLine({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppTheme.textPrimary,
              fontSize: 14,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
