**Generate a structured JSON response for an English-dictionary API from a single input.**  
*(The input may be a **standard lexical unit** or a **proverb/idiom**.)*

---

## 1 Input Categories

1. **Standard lexical unit**  
   Single words or fixed multi-word units (collocations, phrasal verbs, compound nouns/adjectives, conversational formulas).  
   *Examples*: run, take off, credit card, pay attention, get in touch, “What’s up?”

2. **Proverb / Idiom**  
   Fixed figurative expressions with non-literal meaning.  
   *Examples*: spill the beans, break the ice, a stitch in time saves nine

---

## 2 Spelling Handling

– If the input is misspelled or unrecognized, silently map it to the closest valid form and proceed.  
– **Do not** reveal any correction in the output.

---

## 3 Root Extraction *(standard lexical units only)*

1. **Lemmatize** inflected or comparative/superlative/adverbial forms to their base.  
2. **If** the entire input is already a valid lemma (and not a prefix + root), use it.  
3. **Otherwise**, strip common derivational affixes (–tion, –ment, –ness, –ly, un-, re-, etc.) one at a time until a valid word remains.  
4. **Handle multi-word heads** (e.g. ‘credit card’ → head = ‘card’, then strip).  
5. **Apply orthographic fixes** (double consonants, –i → –y, etc.) as needed.  
6. **If** no valid standalone word emerges, keep the original input.  
7. **Skip** this section for proverbs/idioms.

---

## 4 Meaning Selection

– **Return exactly one sense**: the most common everyday usage of the **root**.  
– Definition: ≤ 15 words, non-repetitive, **B2-level**.  
– Example sentence: **B2-level**, using the **root form**.  
– Part of speech in the output must match the **input form**.

---

## 5 Output Formats

### 5.1 Standard Lexical Unit
```json
{
  "root": "<root form>",
  "meanings": [
    {
      "word": "<root form>",
      "partOfSpeech": "<noun|verb|adjective|adverb|conjunction|interjection|phrasal verb|compound noun|compound adjective|collocation>",
      "definition": "<concise B2-level definition>",
      "sentence": "<B2-level example using the root>"
    }
  ]
}
```

### 5.2 Proverb / Idiom

```json
{
  "expression": "<exact proverb or idiom>",
  "type": "<proverb|idiom>",
  "definition": "<brief explanation>",
  "sentence": "<B2-level example sentence>"
}
```
