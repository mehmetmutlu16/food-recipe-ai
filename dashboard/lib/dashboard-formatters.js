import { extractNormalizedIngredients } from './ingredient-normalizer';

export function formatDateTime(value) {
  if (!value) {
    return '-';
  }

  const date = new Date(value);
  if (Number.isNaN(date.getTime())) {
    return '-';
  }

  return date.toLocaleString('tr-TR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
}

export function formatIngredientText(item) {
  const list = extractNormalizedIngredients(item);

  if (list.length > 0) {
    return truncate(list.join(', '), 72);
  }

  return '-';
}

export function formatStatusLabel(status) {
  if (status === 'success') {
    return 'Basarili';
  }
  if (status === 'failed') {
    return 'Basarisiz';
  }
  return '-';
}

function truncate(value, maxLength) {
  if (!value || value.length <= maxLength) {
    return value;
  }

  return `${value.slice(0, maxLength)}...`;
}
