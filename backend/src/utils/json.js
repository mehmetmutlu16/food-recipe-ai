export function extractJsonObject(text) {
  let cleaned = String(text ?? '').trim();
  if (!cleaned) {
    throw new Error('AI response is empty.');
  }

  cleaned = cleaned.replace(/^```(?:json)?\s*/i, '');
  cleaned = cleaned.replace(/\s*```$/i, '');

  const start = cleaned.indexOf('{');
  const end = cleaned.lastIndexOf('}');
  if (start >= 0 && end > start) {
    cleaned = cleaned.slice(start, end + 1);
  }

  const parsed = JSON.parse(cleaned);
  if (!parsed || Array.isArray(parsed) || typeof parsed !== 'object') {
    throw new Error('AI response is not a JSON object.');
  }

  return parsed;
}
