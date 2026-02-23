import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../section_title.dart';

class IngredientTextInputSection extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const IngredientTextInputSection({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Yazarak Malzeme Girisi',
          icon: Icons.edit_rounded,
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            boxShadow: AppTheme.cardShadow,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            enableSuggestions: true,
            autocorrect: true,
            maxLines: 4,
            decoration: InputDecoration(
              hintText:
                  'Domates sogan biber...\\n(Bosluk, virgul veya satir ile ayirin)',
              hintMaxLines: 2,
              filled: true,
              fillColor: AppTheme.surfaceColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                borderSide: const BorderSide(color: AppTheme.dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                borderSide: const BorderSide(color: AppTheme.dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                borderSide:
                    const BorderSide(color: AppTheme.primaryColor, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
