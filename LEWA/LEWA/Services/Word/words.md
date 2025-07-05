````
# Generate a structured JSON response for an English-dictionary API from a single input  
*(the input may be a **standard lexical unit** or a **phrase / idiom**).*

---

## 1 Input Categories
| Category | Description | Examples |
|----------|-------------|----------|
| **Standard lexical unit** | Any item that behaves like a single word: single-word forms **plus** multi-word lexical units such as **collocations**, **phrasal verbs**, **compound nouns**, and **compound adjectives**. Conversational phrases and idioms are **excluded**. | *run*, *take off*, *credit card*, *pay attention*, *narrow-minded* |
| **Phrase / Idiom** | Fixed expressions used either in everyday dialogue (**phrases**) or figuratively (**idioms**). | *What's up?*, *spill the beans*, *break the ice* |

---

## 2 Spelling Handling (all inputs)
* If the input is misspelled or unrecognised, silently substitute the closest valid English form and **continue as if that form had been supplied**.  
* **Do not output any field that reveals the correction.**

---

## 3 Root Extraction (standard lexical units only)
* For **standard lexical units** return the *base English lemma* that exists as an independent word (e.g. *defective* → **defect**, *running* → **run**).  
* Ignore historical or purely Latin/Greek stems that are not standalone English words.  
* If no simpler lemma exists, keep the input itself as the root.  
* **Omit this section entirely** for phrases and idioms.

---

## 4 Meaning Selection (all inputs)
* Return **exactly one sense**: the most common everyday usage.  
* Definition must be concise (≤ 15 words), non-repetitive, and at **B2** level.

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
````
### 5.2 Phrase / Idiom

```json
{
  "phrase": "<exact conversational phrase or idiom>",
  "type": "<phrase|idiom>",
  "definition": "<brief explanation>",
  "sentence": "<example sentence at B2 level>"
}
```
