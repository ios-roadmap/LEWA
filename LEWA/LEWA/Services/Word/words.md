## Generate a concise English‑dictionary entry for **one or more** inputs *(word, multi‑word unit, proverb, or idiom) suitable for IELTS Academic Band 7 / CEFR‑B2)*

---

### 0  Parenthetical information

* Text in the **final** parentheses is **metadata only** – never copy it to the output.
* **Multiple items** inside the metadata (joined by **& / , / /**) → treat each as a separate input; output entries separated by `-----`.
* **Single item** → hint for sense selection only.

### 1  Spelling

* Silently correct misspellings.

### 2  Root extraction *(standard lexical units only)*

#### 2.0  Special check for **‑ing / ‑ed** forms

1. **Category change (verb → adjective)** – e.g. *daunting, gifted*

   * `word = input`
   * `root =` base verb after stripping **‑ing / ‑ed** and lemmatising (→ *daunt*, *gift*).
2. **No category change (still verb)** – e.g. *liking, liked*

   * Lemmatise (*like*), then `root = word` (they match).
3. Otherwise continue with § 2.1.

#### 2.1  Two‑stage algorithm

1. **Inflection stripping:** Lemmatise inflected forms to their dictionary lemma → `word`.
2. **Derivational stripping loop:** Repeatedly remove **one** affix at a time until a valid base remains; if all fail, `root = word`.

   * **Prefixes (outermost first):** un‑, re‑, mis‑, dis‑, over‑, under‑, non‑, pre‑, post‑, anti‑, counter‑, inter‑, trans‑, out‑, in‑, en‑, de‑.
   * **Suffixes / alternations (stop after first success each pass):**

| plain removal                                    | alternation (remove & replace)                                       |
| ------------------------------------------------ | -------------------------------------------------------------------- |
| ‑ness, ‑less, ‑ment, ‑ship, ‑hood, ‑age          | **‑ation/‑ion/‑sion/‑tion/‑ition** → +e if stem ends **‑at/‑it/‑ac** |
| ‑er, ‑or, ‑ee, ‑ist, ‑ism, ‑ess, ‑ette           | **‑ification** → **‑ify**                                            |
| ‑ant, ‑ent, ‑ate, ‑ive, ‑ous, ‑ful, ‑able, ‑ible | **‑ization/‑isation** → **‑ize/‑ise**                                |
| ‑al (not ‑ical), ‑ity                            | **‑ical** → **‑y**                                                   |
|                                                  | **‑ic** → **‑y**                                                     |
|                                                  | **‑ance/‑ancy** → **‑ant** or drop **‑e**                            |
|                                                  | **‑ence/‑ency** → **‑ent** or drop **‑e**                            |
|                                                  | **‑able/‑ible** (on verb bases) → remove, add **‑e** if needed       |

#### 2.2  Validation

* Reject stripping that distorts meaning.
* Roots under 3 letters only if a recognised lemma (*go*).

#### 2.3  Examples

| input            | word             | root       | key rule        |
| ---------------- | ---------------- | ---------- | --------------- |
| studies          | study            | study      | inflection      |
| misunderstanding | misunderstanding | understand | mis‑            |
| denomination     | denomination     | denominate | ‑ation→+e       |
| surgical         | surgical         | surgery    | ‑ical→‑y        |
| economic         | economic         | economy    | ‑ic→‑y          |
| clarification    | clarification    | clarify    | ‑ification→‑ify |
| modernization    | modernization    | modernize  | ‑ization→‑ize   |
| disturbance      | disturbance      | disturb    | ‑ance→Ø         |
| vacancy          | vacancy          | vacant     | ‑ancy→‑ant      |
| frequency        | frequency        | frequent   | ‑ency→‑ent      |
| debatable        | debatable        | debate     | ‑able→+e        |
| daunting         | daunting         | daunt      | § 2.0‑1         |
| liked            | like             | like       | § 2.0‑2         |

### 3  Meaning selection

* **Definition:** ≤ 15 words, B2 vocabulary, start lowercase, state the core action/state/object directly.
* **Sentence (16‑20 words):**

  * Include the **word** exactly once (exclude root unless identical).
  * Must contain **exactly one** Academic Word List word/collocation **and** **exactly one** less‑frequent B2 word (e.g. *restrict, container, overflow*).
  * Formal register; no contractions.
  * Use **exactly one** grammar device (cycle): concessive, conditional 0‑3, reason, purpose, result, contrast, relative, participle, linking adverb, inversion, cleft.

### 4  Output format

For a **standard lexical unit**:

```
root: <root>
word: <entry headword>      # lemma
definition: <concise definition>
sentence: <example sentence>
```

For a **proverb / idiom**:

```
expression: <exact phrase>
definition: <concise explanation>
sentence: <example sentence>
```

Multiple inputs → output entries separately, separated by `-----`.
