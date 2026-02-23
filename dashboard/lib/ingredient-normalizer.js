function normalize(value) {
  return String(value ?? '').trim().toLowerCase().replace(/\s+/g, ' ');
}

function hasExplicitSeparators(value) {
  return /[,;\n]/.test(value);
}

function splitText(value, allowWhitespaceFallback) {
  const text = String(value ?? '').trim();
  if (!text) {
    return [];
  }

  const delimiter = hasExplicitSeparators(text)
    ? /[,;\n]/
    : allowWhitespaceFallback
      ? /\s+/
      : null;

  if (!delimiter) {
    const single = normalize(text);
    return single ? [single] : [];
  }

  return text
    .split(delimiter)
    .map((item) => normalize(item))
    .filter(Boolean);
}

function unique(values) {
  const seen = new Set();
  const result = [];

  for (const value of values) {
    const key = normalize(value);
    if (!key || seen.has(key)) {
      continue;
    }

    seen.add(key);
    result.push(key);
  }

  return result;
}

export function extractNormalizedIngredients(item) {
  const recognized = Array.isArray(item?.recognizedIngredients)
    ? item.recognizedIngredients
        .map((entry) => String(entry ?? '').trim())
        .filter(Boolean)
    : [];

  const rawText = String(item?.rawIngredientsText ?? '').trim();

  if (recognized.length > 1) {
    return unique(recognized);
  }

  if (recognized.length === 1) {
    const only = recognized[0];
    const shouldUseWhitespaceFallback =
      rawText.length > 0 && normalize(rawText) === normalize(only);
    return unique(splitText(only, shouldUseWhitespaceFallback));
  }

  if (!rawText) {
    return [];
  }

  return unique(splitText(rawText, true));
}
