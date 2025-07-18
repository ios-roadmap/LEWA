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

### 2  Root extraction *(standard lexical units only)*

**Headwords (`word`) must always be dictionary lemmas.**
Never output an inflected form (e.g. plural, -ed, -ing, 3rd person) as the `word`.

Perform derivational analysis systematically:

* Start with **inflection stripping**:

  * Lemmatise inflected forms (e.g. *studies, running, dug*) to their dictionary lemma.
  * Set the lemma as `word`.

* Continue with **prefix stripping** (remove one at a time: *un‑, re‑, mis‑, dis‑, over‑*, etc.) and then **suffix stripping** (remove one at a time: *‑al, ‑ity, ‑ous, ‑ly, ‑ment, ‑ance, ‑ence, ‑ant, ‑ent*, etc.) until a valid base form is found:

  * If the resulting stripped form is valid, meaningful, and retains core meaning, set it as `root`.
  * If stripping distorts the sense or yields no valid base, set `root = word` (the lemma itself).

Examples:

* input: *harassment*
  → word: **harassment** (dictionary lemma), root: **harass**

* input: *studies*
  → word: **study**, root: **study**

* input: *misunderstanding*
  → word: **misunderstanding** (dictionary lemma), root: **understand**

---

### 3  Meaning selection

Provide **one** common, everyday sense of the input’s part of speech, guided (if present) by the parenthetical metadata.

* **Definition** – ≤ 15 words, B2 vocabulary, start with a lowercase letter.
* **Example sentence (16‑20 words):**

  * Include the **word** (headword without parentheses) **exactly once**.
  * Do **not** include the root unless identical to the word.
  * Must contain **exactly one** Academic Word List (AWL) word or collocation.
  * Must contain **exactly one** less‑frequent B2 word (e.g. *restrict, container, overflow*).
  * Use formal register; avoid contractions.
  * Include **exactly one** of the following grammar devices (cycle them across calls):

    * concessive clause (*although, even though, though*)
    * conditional clause (Type 0‑3 or mixed)
    * reason clause (*because, since, as*)
    * purpose clause (*so that, in order that, so as to*)
    * result clause (*so … that, such … that*)
    * contrast clause (*while, whereas*)
    * relative clause (defining / non‑defining)
    * participle clause (present / past / perfect)
    * linking adverb (*however, therefore, nevertheless, moreover, consequently*)
    * inversion (condition / concession)
    * cleft sentence for emphasis

---

### 4  Output format

**For a standard lexical unit:**

```
root: <root>
word: <entry headword>      # always lemma
definition: <concise definition>
sentence: <example sentence>
```

**For a proverb / idiom:**

```
expression: <exact phrase>
definition: <concise explanation>
sentence: <example sentence>
```

When processing multiple inputs, format each entry separately and separate them with `-----`.

---
