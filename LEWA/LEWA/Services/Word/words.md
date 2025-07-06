**Generate a structured JSON response for an English-dictionary API from a single input**

*(the input may be a **standard lexical unit** or a **proverb / idiom**).*

---

## 1 Input Categories

### **Standard lexical unit**

Any item that behaves like a single word: single-word forms *plus* multi-word lexical units such as collocations, phrasal verbs, compound nouns, compound adjectives, and fixed conversational formulas (e.g. “What’s up?”, “Nice to meet you”). Everything except proverbs and idioms belongs here.
*Examples*: run, take off, credit card, pay attention, get in touch, What’s up?

### **Proverb / Idiom**

Fixed figurative expressions conveying a moral, lesson, or non-literal meaning.
*Examples*: spill the beans, break the ice, a stitch in time saves nine

---

## 2 Spelling Handling (all inputs)

* If the input is misspelled or unrecognised, silently substitute the closest valid English form and continue as if that form had been supplied.
* **Do not output any field that reveals the correction.**

---

## 3 Root Extraction (standard lexical units only)

1. **If the entire input is already a valid standalone English lemma *and* is not normally analysed in modern usage as a straightforward prefix + root combination (e.g. *prolong* → *prolong*), treat the whole input as the root and stop.**
2. Otherwise, return the base English lemma that exists as an independent word.
3. **Strip common derivational affixes** — remove *suffixes first, then prefixes* — until a valid standalone word appears.

   * **Suffixes**:
     –tion, –sion, –ssion, –ation, –ment, –ance, –ence, –ness, –ity, –ship, –hood, –age, –al, –acy, –ery, –ure, –ist, –ism, –er, –or, –ive, –ous, –ious, –less, –ful, –able, –ible, –ic, –ical, –ize/–ise, –ant, –ate, –y
   * **Prefixes**:
     un-, in-, im-, il-, ir-, non-, dis-, mis-, de-, ex-, re-, pre-, post-, sub-, super-, under-, over-, anti-, counter-, co-, inter-, trans-, pro-, micro-, macro-, hyper-, ultra-
4. **Orthographic adjustments** (apply after affix-stripping, in this order):

   1. If the stripped form ends in **two identical consonants** and removing one yields a valid standalone word, adopt the shorter form (e.g. **runn** → **run**).
   2. If it ends in **t** and replacing that **t** with **ce** yields a valid standalone word, adopt it (e.g. **conscient** → **conscience**).
   3. If it ends in **on** and replacing **on** with **ence** yields a valid standalone word, adopt it (e.g. **conscion** → **conscience**).
   4. If it ends in **i** and replacing **i** with **y** yields a valid standalone word, adopt it (e.g. **remedi** → **remedy**).
5. **Compound nouns (and other compounds)**

   * Identify the head word (usually the right-most element, e.g. *learning* in *rote learning*).
   * Apply the affix-stripping and orthographic rules above to that head word to derive the root (e.g. *learning* → strip –ing → **learn**).
6. If stripping yields another valid word **and** that shorter word is listed in contemporary dictionaries as the morphological base (e.g. *admission* → **admit**), output the shorter word; otherwise keep the original input (e.g. *prolong* → **prolong**).
7. If no valid standalone English word emerges, keep the original input as the root.
8. **Omit this section entirely** for proverbs and idioms.

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
