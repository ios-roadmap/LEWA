# LEWA!
 - Learn English With AI

<p align="center">
  <img src="https://github.com/user-attachments/assets/708fd5c2-9eef-466a-bf65-9146dea0b2c6" alt="search" width="250" style="margin-right:8px;"/>
  <img src="https://github.com/user-attachments/assets/29f62f05-23b5-4b5d-857c-f5d5cf6e2228" alt="detail" width="250" style="margin-right:8px;"/>
</p>

**Unified Word-Analysis & Family Prompt (IELTS Academic)**

> **Task**
> Act as an English–Turkish bilingual vocabulary assistant.
> For the single input word **{word}**, return **only**:
>
> 1. A valid JSON object that follows the schema below.
> 2. **Immediately after the closing brace, one extra line** that lists the `root` **followed by every `word` in `wordFamilies`, all separated by commas**—nothing else.

### Output schema

```json
{
  "root": "",               // shortest lemma of {word}
  "meanings": [
    {
      "sentence": "",       // 10–20-word B2 English sentence
      "trSentence": "",     // Turkish translation
      "definition": "",     // ≤ 20-word English definition
      "partOfSpeech": ""    // noun, verb, adjective, etc.
    }
  ],
  "wordFamilies": [
    {
      "word": "",           // derived form (not the root)
      "partOfSpeech": "",   // noun, verb, adjective, etc.
      "sentence": "",       // 10–20-word B2 English sentence
      "trSentence": "",     // Turkish translation
      "definition": ""      // ≤ 20-word English definition
    }
  ]
}
```

### Rules

1. **root** – give only the shortest standard form (e.g., `run` for `running`).
2. **wordFamilies** – include **all** valid forms built from the root using these affixes **plus** other common IELTS-relevant derivatives (lowercase, root excluded):
   *Suffixes*: -s, -es, -ed, -ing, -en, -er, -est, -ly, -ness, -ment, -tion, -ation, -ity, -ship, -hood, -ous, -ful, -less, -y, -ish, -al, -ive, -ist, -ism, -dom
   *Prefixes*: un-, in-, im-, il-, ir-, dis-, non-, re-, pre-, sub-, over-, under-, en-, de-
3. **meanings** – one object per distinct sense; adhere to the sentence/definition length limits and avoid duplicate sentences.
4. **No English Equivalent** – if {word} has no direct English form, choose the closest English equivalent and apply all rules to it.
5. Ensure the JSON is strictly valid: double quotes only, correct commas, no comments.
6. **After the JSON**, output **exactly one line**:

   ```
   root,familyWord1,familyWord2,...
   ```

   *No labels, no spaces around commas, no extra text.*
