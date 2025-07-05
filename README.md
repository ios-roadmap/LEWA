# LEWA!
 - Learn English With AI

<p align="center">
  <img src="https://github.com/user-attachments/assets/708fd5c2-9eef-466a-bf65-9146dea0b2c6" alt="search" width="250" style="margin-right:8px;"/>
  <img src="https://github.com/user-attachments/assets/29f62f05-23b5-4b5d-857c-f5d5cf6e2228" alt="detail" width="250" style="margin-right:8px;"/>
</p>

Generate a structured JSON response for an English dictionary API based on a provided word or idiomatic expression. The JSON structure includes two different models depending on input type: standard words or idioms/phrases.

## 📌 Root Determination Rule:

When determining the **root** form of the provided word, strictly follow these rules:

* **Verbs**: Always use the infinitive (base form).
  Examples:

  * **running** → **run**
  * **went** → **go**

* **Nouns**: Generally use the singular form. However, if the noun is commonly used only in plural form (without a commonly used singular form), keep the plural as the root form.
  Examples:

  * **books** → **book**
  * **scissors** → **scissors**
  * **trousers** → **trousers**

* **Adjectives and Adverbs**: Always use the base form (positive form), not comparative or superlative.
  Examples:

  * **fastest** → **fast**
  * **quickly** → **quick**

* **If the base form of a word is no longer commonly used in contemporary English**, keep the provided form as the root.
  Examples:

  * **uncanny** → **uncanny** (because "canny" is rarely used)

## 🔑 Important rules for meanings:

* **Select only the most commonly used meanings** of the provided word (maximum 3-4 meanings).
* **Avoid repetition**: Meanings should clearly differ and should not duplicate each other.

---

## 📝 Models:

You should create one of the following two models, depending on the input type:

### ① Standard Word Model:

* **root**: (string) The root form of the provided input word (determined by the rules above).
* **meanings**: (array) A list of most commonly used meanings. Each meaning object should include:

  * **word**: (string) The exact form of the provided input word.
  * **sentence**: (string) A B2-level example sentence clearly demonstrating the usage of the provided word in this specific meaning context.
  * **definition**: (string) A brief, clear, non-repetitive definition suitable for B2-level learners.
  * **partOfSpeech**: (string) The grammatical category of the provided word in this meaning context (noun, verb, adjective, adverb, conjunction, interjection, phrasal verb, compound noun).

### ② Idioms/Phrases Model:

* **phrase**: (string) The idiomatic expression or common phrase exactly as provided.
* **type**: (string) Specify clearly: "idiom" or "phrase".
* **definition**: (string) A brief, clear, non-repetitive explanation suitable for B2 learners.
* **sentence**: (string) A B2-level example sentence clearly demonstrating usage of the idiom or phrase.

---

## ✅ Example Input and Output:

### Example Input (Standard Word):

```
word: running
```

### Example Output (Standard Word):

```json
{
  "root": "run",
  "meanings": [
    {
      "word": "running",
      "sentence": "She enjoys running every morning to stay healthy.",
      "definition": "The activity of moving rapidly on foot as a sport or for exercise.",
      "partOfSpeech": "noun"
    },
    {
      "word": "running",
      "sentence": "The car engine was running smoothly.",
      "definition": "To operate or function.",
      "partOfSpeech": "verb"
    }
  ]
}
```

### Example Input (Idiom/Phrase):

```
phrase: what's up
```

### Example Output (Idiom/Phrase):

```json
{
  "phrase": "what's up",
  "type": "idiom",
  "definition": "An informal greeting meaning 'how are you' or 'what's happening'.",
  "sentence": "Hey Tom, what's up?"
}
```
