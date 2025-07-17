## Generate a concise English‑dictionary entry for **one or more** inputs

*(word, multi‑word unit, proverb, or idiom) suitable for IELTS Academic Band 7 / CEFR‑B2.*

---

### 0  Parenthetical information

The input may include text in parentheses immediately after the headword, e.g.
  `proportional (directly & inversely)` or `run (verb)` or `bank (TR: banka)`

* Treat everything inside the **final** pair of parentheses as **metadata only**.

  * It may signal sense, part of speech, translation, or other context.
  * **Never copy the parentheses or their contents into the output.**
* **Multiple items:** If the metadata lists several alternatives—joined by **&**, **/**, or commas—treat *each* item as a separate input:

  * Generate a separate entry for every listed item (e.g. *directly proportional* and *inversely proportional*).
  * Format the multiple entries exactly as in § 4 and separate them with `-----`.
* **Single item:** If the metadata contains only one item, use it simply to select the most relevant sense.

---

### 1  Spelling

* Silently correct misspellings; do **not** mention the correction.

---

### 2  Root extraction — **absolutely no inflection in the output**

> **🔴 Mandatory rule:** If the input differs from its dictionary lemma **only by an inflectional ending**
> ‑ verbs (‑s, ‑ed, ‑en, ‑ing) ‑ nouns (plural ‑s/‑es) ‑ adjectives (comparative ‑er, superlative ‑est)
> **then:**
>
> * set **`root = word = the lemma`**;
> * **never show** the original inflected form anywhere;
> * write the `definition` and `sentence` with that lemma.

Headwords must always be dictionary lemmas. Never output an inflected form as the `word` field.

1. **Inflection** – lemmatise all inflected forms. If lemmatisation is the only change, stop here (rule above).
2. **Candidate lemma check** – if the lemma is valid and has **no derivational suffix**, set `root = word = lemma`.
3. **Prefix stripping** – remove one recognised derivational prefix (un‑, re‑, mis‑, dis‑, over‑, etc.) until a valid word appears; the first valid word becomes **root**.
4. **Suffix stripping** – after prefix stripping, remove one recognised derivational suffix (‑al, ‑ity, ‑ous, ‑ly, ‑ment, ‑ance, ‑ence, ‑ant, ‑ent, etc.) until a valid word appears.
   *If removing a suffix changes the core meaning, keep the longer form as **word** and the shorter valid form as **root**.*
5. **Multi‑word heads** – for noun compounds, isolate the head noun first, then apply steps 1‑4. For phrasal verbs, treat the verb only (*look after* → *look*).
6. **Orthography** – make minor fixes if needed (‑i → ‑y, double consonants).
7. **Fallback** – if no valid word emerges, use the original input as the **root**.

---

### 3  Meaning selection

Provide **one** common, everyday sense of the input’s part of speech, guided (if present) by the parenthetical metadata.

* **Definition** – ≤ 15 words, B2 vocabulary, start with a lowercase letter, use the lemma only.
* **Example sentence (16‑20 words):**

  * Include the **word** (identical to `root`) **exactly once**.
  * Must contain **exactly one** Academic Word List (AWL) word or collocation.
  * Must contain **exactly one** less‑frequent B2 word (e.g. *restrict, container, overflow*).
  * Use formal register; avoid contractions.
  * Include **exactly one** of the grammar devices listed below (cycle them across calls):
    • concessive clause (*although, even though, though*)
    • conditional clause (Type 0‑3 or mixed)
    • reason clause (*because, since, as*)
    • purpose clause (*so that, in order that, so as to*)
    • result clause (*so … that, such … that*)
    • contrast clause (*while, whereas*)
    • relative clause (defining / non‑defining)
    • participle clause (present / past / perfect)
    • linking adverb (*however, therefore, nevertheless, moreover, consequently*)
    • inversion (condition / concession)
    • cleft sentence for emphasis

---

### 4  Output format

**Standard lexical unit**

```
root: <root>
word: <headword>            # always identical to root for purely inflected inputs
definition: <concise definition>
sentence: <example sentence>
```

**Proverb / idiom**

```
expression: <exact phrase>
definition: <concise explanation>
sentence: <example sentence>
```

When processing multiple inputs, format each entry separately and separate them with `-----`.
