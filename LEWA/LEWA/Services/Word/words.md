# Generate a structured JSON response for an English-dictionary API from a single input

*(the input may be a **standard lexical unit** or a **proverb / idiom**).*

---

## 1 Input Categories

**Standard lexical unit**
Any item that behaves like a single word: single-word forms *plus* multi-word lexical units such as collocations, phrasal verbs, compound nouns, compound adjectives, and fixed conversational formulas (e.g. “What’s up?”, “Nice to meet you”). Everything except proverbs and idioms belongs here.
*Examples*: run, take off, credit card, pay attention, get in touch, What’s up?

**Proverb / Idiom**
Fixed figurative expressions conveying a moral, lesson, or non-literal meaning.
*Examples*: spill the beans, break the ice, a stitch in time saves nine

---

## 2 Spelling Handling (all inputs)

* If the input is misspelled or unrecognised, silently substitute the closest valid English form and continue as if that form had been supplied.
* Do **not** output any field that reveals the correction.

---

## 3 Root Extraction (standard lexical units only)

1. Return the base English lemma that exists as an independent word (e.g. *defective* → **defect**, *running* → **run**).

2. **Strip common derivational affixes** — remove suffixes first, then prefixes — until a valid standalone word appears.

   **Suffixes**:
   -tion, -sion, -ssion, -ation, -ment, -ance, -ence, -ness, -ity, -ship, -hood, -age, -al, -acy, -ery, -ure, -ist, -ism, -er, -or, -ive, -ous, -ious, -less, -ful, -able, -ible, -ic, -ical, -ize / -ise
   *Examples*: admission → admit; movement → move; possibility → possible; darkness → dark; happiness → happy; worker → work.

   **Prefixes**:
   un-, in-, im-, il-, ir-, non-, dis-, mis-, de-, ex-, re-, pre-, post-, sub-, super-, under-, over-, anti-, counter-, co-, inter-, trans-, pro-, micro-, macro-, hyper-, ultra-
   *Examples*: unknown → know; rebuild → build; disagree → agree; preview → view.

3. **Orthographic adjustments** (apply in this order):

   * If the stripped form ends in **t** and replacing that **t** with **ce** yields a valid standalone word, adopt the corrected form (e.g. *conscient* → **conscience**).
   * If the stripped form ends in **on** and replacing **on** with **ence** yields a valid standalone word, adopt the corrected form (e.g. *conscion* → **conscience**).

4. If the stripped (and, if needed, adjusted) form is **not** a valid standalone English word, keep the original input as the root.

5. If the input can be parsed both as an independent word and as a derived form, treat it as derived and output the root (e.g. *admission* → **admit**).

6. Ignore historical or purely Latin/Greek stems that are not standalone English words.

7. **Omit this section entirely** for proverbs and idioms.

---

## 4 Meaning Selection (all inputs)

* Return **exactly one sense**: the most common everyday usage.
* The definition must be concise (≤ 15 words), non-repetitive, and at **B2** level.

---

## 5 Output Formats

Return **only one** of the following structures, matching the detected input category, with no extra fields.

### 5.1 Standard Lexical Unit

```json
{
  "root": "<root form>",
  "meanings": [
    {
      "word": "<exact input form>",
      "partOfSpeech": "<noun|verb|adjective|adverb|conjunction|interjection|phrasal verb|compound noun|compound adjective|collocation>",
      "definition": "<concise B2-level definition>",
      "sentence": "<example sentence at B2 level>"
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
  "sentence": "<example sentence at B2 level>"
}
```
