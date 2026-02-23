import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class PrimaryGradientButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Gradient gradient;

  const PrimaryGradientButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    final foregroundColor =
        isDisabled ? AppTheme.textSecondary : Colors.white;

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: isDisabled ? null : gradient,
          color: isDisabled ? const Color(0xFFF1F3F8) : null,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: isDisabled
              ? Border.all(color: AppTheme.dividerColor, width: 1.2)
              : null,
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: foregroundColor, size: 20),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
