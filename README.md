# LEWA - Learn English With AI

## Professional Dictionary JSON Generation Prompt

You are given an input object which may contain: `word`, `type`, `meanings`, `phonetics`. Your task is to generate a **fully-structured JSON object** for a professional, extensible English (UK) dictionary database, strictly following the specifications below:

---

### GENERAL RULES

- **All field names must be in lowercase.**
- **Return ONLY the required fields, in the exact structure and order below. No extra fields, no comments, no explanations.**
- **Return only the JSON object, enclosed in a single code block: \`\`\`json ... \`\`\`**
- For multiple input words, output a separate JSON object for each word (no arrays wrapping the objects).

---

### ROOT FORM

- Use the **root (base) form** of the word as the main `"word"`.  
  E.g., for "deserted", output `"word": "desert"`.
- **Never include the root word itself in the `"word_family"` array.**

---

### TOP-LEVEL JSON STRUCTURE

```json
{
  "id": "",
  "word": "root word",
  "phonetics": [
    {
      "accent": "uk",
      "ipa": "UK IPA of root word",
      "audio": ""
    }
  ],
  "meanings": [ ... ],
  "word_family": [ ... ]
}
````

#### FIELD DETAILS

* **id**: Always an empty string (`""`).
* **word**: The root form (base) of the input word, in lowercase.
* **phonetics**: Array of one object:

  * **accent**: `"uk"`
  * **ipa**: UK IPA for the **word only**.
  * **audio**: Always `""`.

---

### MEANINGS (array)

Include **all common, current, and widely used senses** of the root word as separate objects, even if they differ in part of speech or meaning.
**Exclude rare, obsolete, or archaic senses.**

Each meaning must have the following structure:

```json
{
  "type": "noun|verb|adjective|adverb|preposition|conjunction|interjection|abbreviation",
  "definition": "Concise, context-appropriate English (UK) definition.",
  "image": "",
  "sentence": {
    "text": "B2-level English example sentence.",
    "audio": "",
    "translations": [
      {
        "lang": "tr",
        "text": "Faithful Turkish translation of the example."
      }
    ]
  },
  "synonyms": [
    { "id": "", "word": "...", "type": "..." }
  ],
  "antonyms": [
    { "id": "", "word": "...", "type": "..." }
  ]
}
```

#### DEFINITION TEMPLATES

* **Noun**: `"A [simple explanation]."`
* **Verb**: `"To [base form + simple explanation]."`
* **Adjective**: `"Describes someone or something that is [simple explanation]."`
* **Adverb**: `"In a [manner/explanation] way."`
* **Preposition**: `"Used to show [relationship]."`
* **Conjunction**: `"Used to connect [clauses/words/ideas]."`
* **Interjection**: `"Used to express [emotion/surprise/reaction]."`
* **Abbreviation**: `"A shortened form of [phrase/word]."`

#### ADDITIONAL RULES FOR MEANINGS

* **Sentence** must be B2 level, contextually accurate.
* **Turkish translation** must be faithful, clear, and context-appropriate.
* **All `"audio"` and `"id"` fields are always empty (`""`).**
* **All `"image"` fields are always empty (`""`).**
* **All `"phonetics"` relate to the word, NOT the sentence.**
* Include at least one synonym or antonym where possible. If none, use an empty array.

---

### WORD\_FAMILY (array)

List all direct, common, **morphological relatives** (excluding the root word).
If none, use an empty array.

Each object has the following structure:

```json
{
  "word": "related word",
  "type": "part of speech",
  "phonetics": [
    {
      "accent": "uk",
      "ipa": "UK IPA for related word",
      "audio": ""
    }
  ],
  "definition": "Short, context-appropriate English definition.",
  "sentence": {
    "text": "B2-level English example sentence.",
    "audio": "",
    "translations": [
      {
        "lang": "tr",
        "text": "Faithful Turkish translation of the example."
      }
    ]
  }
}
```

* **word**: Related morphological form (e.g., adjectives, adverbs, nouns, verbs).
* **type**: Part of speech of the related form.
* **phonetics**: As above, but for the related word.
* **definition**: Short, context-appropriate English definition.
* **sentence**: B2-level English example sentence using the related form; with Turkish translation.

---

### STYLE & ACCURACY

* Example sentences and definitions must be at **B2 (upper-intermediate) level**.
* Turkish translations must be clear, concise, and contextually faithful.
* Do not change a provided word, sentence, or type unless correcting an obvious typo or missing value.
* Never add extra comments, instructions, or metadata.

---

### EXAMPLE OUTPUT

```json
{
  "id": "",
  "word": "scruff",
  "phonetics": [
    {
      "accent": "uk",
      "ipa": "skrʌf",
      "audio": ""
    }
  ],
  "meanings": [
    {
      "type": "noun",
      "definition": "The back part of the neck, especially where an animal's fur is thicker.",
      "image": "",
      "sentence": {
        "text": "She grabbed the cat by the scruff of its neck.",
        "audio": "",
        "translations": [
          {
            "lang": "tr",
            "text": "Kediyi ensesinden yakaladı."
          }
        ]
      },
      "synonyms": [
        { "id": "", "word": "nape", "type": "noun" }
      ],
      "antonyms": []
    }
  ],
  "word_family": [
    {
      "word": "scruffy",
      "type": "adjective",
      "phonetics": [
        {
          "accent": "uk",
          "ipa": "ˈskrʌfi",
          "audio": ""
        }
      ],
      "definition": "Describes someone or something that is untidy or dirty in appearance.",
      "sentence": {
        "text": "He turned up to the interview in a scruffy old jacket.",
        "audio": "",
        "translations": [
          {
            "lang": "tr",
            "text": "Mülakata eski ve dağınık bir ceketle geldi."
          }
        ]
      }
    },
    {
      "word": "scruffily",
      "type": "adverb",
      "phonetics": [
        {
          "accent": "uk",
          "ipa": "ˈskrʌfɪli",
          "audio": ""
        }
      ],
      "definition": "In a messy or untidy way.",
      "sentence": {
        "text": "He was scruffily dressed for the meeting.",
        "audio": "",
        "translations": [
          {
            "lang": "tr",
            "text": "Toplantı için dağınık bir şekilde giyinmişti."
          }
        ]
      }
    },
    {
      "word": "scruffiness",
      "type": "noun",
      "phonetics": [
        {
          "accent": "uk",
          "ipa": "ˈskrʌfinəs",
          "audio": ""
        }
      ],
      "definition": "The quality of being untidy or dirty.",
      "sentence": {
        "text": "His scruffiness made a bad impression.",
        "audio": "",
        "translations": [
          {
            "lang": "tr",
            "text": "Dağınıklığı kötü bir izlenim bıraktı."
          }
        ]
      }
    }
  ]
}
```

Note: Include all common, primary, and major senses of the root word, covering every widely used noun, verb, adjective, and other important usages. Do not omit any main sense, even if it is not directly related to the inflected form provided.
