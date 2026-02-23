export const recognitionSystemInstruction = `
You are an expert food-vision parser.
Always return valid JSON only.
No markdown, no prose.
`;

export const recipeSystemInstruction = `
You are a senior Turkish culinary assistant.
Write recipe content in Turkish language.
Always return valid JSON only.
No markdown, no prose.
`;

export function buildRecognitionPrompt() {
  return `
<task>
Extract only edible food ingredients from the image.
Ignore cookware, packaging brands, labels, and non-food objects.
</task>

<constraints>
- Normalize ingredient names to short Turkish nouns.
- Return strict JSON object only.
</constraints>

<schema>
{
  "recognizedIngredients": ["string"]
}
</schema>

<few_shot_examples>
Input hint: tomatoes, onion, pan
Output: {"recognizedIngredients":["domates","sogan"]}

Input hint: plate and glass only
Output: {"recognizedIngredients":[]}
</few_shot_examples>
`;
}

export function buildRecipePrompt({ ingredients, notes }) {
  const ingredientText = ingredients.join(', ');
  const notesText = notes && notes.trim().length > 0 ? notes.trim() : '-';

  return `
<context>
Available ingredients: ${ingredientText}
User notes: ${notesText}
</context>

<task>
Create one practical Turkish home recipe.
</task>

<constraints>
- Keep output in Turkish (name, ingredients, steps).
- Difficulty must be one of: easy, medium, hard.
- Use mostly provided ingredients.
- You may add only basic pantry items if required: tuz, karabiber, su, zeytinyagi, siviyag.
- Return strict JSON object only.
</constraints>

<schema>
{
  "name": "string",
  "ingredients": [{"name":"string","quantity":1,"unit":"string"}],
  "steps": ["string"],
  "prepTimeMinutes": 30,
  "difficulty": "easy"
}
</schema>

<few_shot_example>
Input: yumurta, domates, biber
Output:
{
  "name":"Menemen",
  "ingredients":[
    {"name":"yumurta","quantity":3,"unit":"adet"},
    {"name":"domates","quantity":2,"unit":"adet"},
    {"name":"biber","quantity":2,"unit":"adet"},
    {"name":"siviyag","quantity":1,"unit":"yemek kasigi"},
    {"name":"tuz","quantity":1,"unit":"cay kasigi"}
  ],
  "steps":[
    "Biberleri dograyip yagda 2-3 dakika kavurun.",
    "Domatesleri ekleyip suyunu cekene kadar pisirin.",
    "Yumurtalari kirip karistirarak pisirin.",
    "Tuz ekleyip sicak servis edin."
  ],
  "prepTimeMinutes":15,
  "difficulty":"easy"
}
</few_shot_example>
`;
}
