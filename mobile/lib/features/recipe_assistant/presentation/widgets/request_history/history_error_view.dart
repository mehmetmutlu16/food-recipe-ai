import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';

class HistoryErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const HistoryErrorView({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.history_toggle_off_rounded,
              size: 44,
              color: AppTheme.textHint,
            ),
            const SizedBox(height: 10),
            const Text(
              'Gecmis verisi alinamadi.',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tekrar dene'),
            ),
          ],
        ),
      ),
    );
  }
}
