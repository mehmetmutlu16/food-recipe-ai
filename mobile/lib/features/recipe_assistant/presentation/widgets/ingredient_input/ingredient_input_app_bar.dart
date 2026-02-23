import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class IngredientInputAppBar extends StatelessWidget {
  final VoidCallback onOpenHistory;
  final VoidCallback onResetFlow;

  const IngredientInputAppBar({
    super.key,
    required this.onOpenHistory,
    required this.onResetFlow,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      pinned: true,
      backgroundColor: AppTheme.surfaceColor,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: const FlexibleSpaceBar(
        title: Text(
          'Tarif Asistani',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        titlePadding: EdgeInsets.only(left: 20, bottom: 14),
        expandedTitleScale: 1.3,
      ),
      actions: [
        IconButton(
          onPressed: onResetFlow,
          icon: const Icon(Icons.restart_alt_rounded),
          tooltip: 'Sifirla',
        ),
        IconButton(
          onPressed: onOpenHistory,
          icon: const Icon(Icons.history_rounded),
          tooltip: 'Gecmis',
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
