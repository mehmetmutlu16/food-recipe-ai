import { extractNormalizedIngredients } from './ingredient-normalizer';

export function getTotals(summary) {
  return summary?.totals ?? { all: 0, success: 0, failed: 0 };
}

export function computeSuccessRate(totals) {
  if (!totals.all) {
    return 0;
  }

  return Math.round((totals.success / totals.all) * 100);
}

export function computeInputTypeData(history) {
  const countMap = { text: 0, image: 0, mixed: 0 };

  for (const item of history) {
    const key = item?.inputType;
    if (key === 'text' || key === 'image' || key === 'mixed') {
      countMap[key] += 1;
    }
  }

  return [
    { type: 'Text', count: countMap.text },
    { type: 'Image', count: countMap.image },
    { type: 'Mixed', count: countMap.mixed }
  ];
}

export function computeSuccessFailureData(totals) {
  return [
    { name: 'Success', value: totals.success },
    { name: 'Failed', value: totals.failed }
  ];
}

export function computeAverageIngredientCount(history) {
  if (!history.length) {
    return 0;
  }

  const totalIngredients = history.reduce((acc, item) => {
    const count = extractNormalizedIngredients(item).length;
    return acc + count;
  }, 0);

  return Number((totalIngredients / history.length).toFixed(1));
}

export function computeTopErrorCodes(history, limit = 6) {
  const map = {};

  for (const item of history) {
    if (item?.status !== 'failed') {
      continue;
    }

    const key = String(item?.errorCode || 'unknown_error').trim();
    map[key] = (map[key] ?? 0) + 1;
  }

  return Object.entries(map)
    .map(([code, count]) => ({ code, count }))
    .sort((a, b) => b.count - a.count)
    .slice(0, limit);
}

export function computeHourlyTrend(history) {
  const hours = Array.from({ length: 24 }, (_, index) => ({
    hour: `${String(index).padStart(2, '0')}:00`,
    count: 0
  }));

  for (const item of history) {
    if (!item?.createdAt) {
      continue;
    }

    const date = new Date(item.createdAt);
    if (Number.isNaN(date.getTime())) {
      continue;
    }

    hours[date.getHours()].count += 1;
  }

  return hours;
}
