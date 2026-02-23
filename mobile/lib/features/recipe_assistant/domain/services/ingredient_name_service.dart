class IngredientNameService {
  IngredientNameService._();

  static String normalize(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  static List<String> parseFreeText(String text) {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) {
      return const [];
    }

    final hasExplicitSeparators = RegExp(r'[,;\n]').hasMatch(trimmedText);
    final delimiter = hasExplicitSeparators ? RegExp(r'[,;\n]') : RegExp(r'\s+');

    return trimmedText
        .split(delimiter)
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList(growable: false);
  }

  static List<String> uniquePreserveOrder(Iterable<String> values) {
    final byKey = <String, String>{};
    for (final value in values) {
      final trimmed = value.trim();
      final key = normalize(trimmed);
      if (trimmed.isEmpty || byKey.containsKey(key)) {
        continue;
      }
      byKey[key] = trimmed;
    }

    return byKey.values.toList(growable: false);
  }
}
