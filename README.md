# LEWA!
 - Learn English With AI

<p align="center">
  <img src="https://github.com/user-attachments/assets/708fd5c2-9eef-466a-bf65-9146dea0b2c6" alt="search" width="250" style="margin-right:8px;"/>
  <img src="https://github.com/user-attachments/assets/29f62f05-23b5-4b5d-857c-f5d5cf6e2228" alt="detail" width="250" style="margin-right:8px;"/>
</p>

**Prompt**

# PART I

> You will receive a single English word **X** (of any type: noun, verb, adjective, adverb, etc.; it may be inflected or derived).
>
> **1.** Identify its **root (base) form**.
>
> **2.** List **every linguistically valid, standard English word form** that can be created from the root using the standard English prefixes and suffixes provided below. Include all possible word classes (noun, verb, adjective, adverb, etc.).
>
> **Return your answer only in this exact JSON structure (no extra keys, comments, or text):**
>
> ```json
> {
>   "root": "<root word here>",
>   "forms": [
>     "<root-s>",
>     "<root-es>",
>     "<root-ed>",
>     "<root-ing>",
>     "<root-en>",
>     "<root-er>",
>     "<root-est>",
>     "<root-ly>",
>     "<root-ness>",
>     "<root-ment>",
>     "<root-tion>",
>     "<root-ation>",
>     "<root-ity>",
>     "<root-ship>",
>     "<root-hood>",
>     "<root-ous>",
>     "<root-ful>",
>     "<root-less>",
>     "<root-y>",
>     "<root-ish>",
>     "<root-al>",
>     "<root-ive>",
>     "<root-ist>",
>     "<root-ism>",
>     "<root-dom>",
>     "<un-root>",
>     "<in-root>",
>     "<im-root>",
>     "<il-root>",
>     "<ir-root>",
>     "<dis-root>",
>     "<non-root>",
>     "<re-root>",
>     "<pre-root>",
>     "<sub-root>",
>     "<over-root>",
>     "<under-root>",
>     "<en-root>",
>     "<de-root>"
>   ]
> }
> ```
>
> **Guidelines**
>
> * Include **only** forms that genuinely exist for the root; omit impossible or nonstandard ones.
> * If the root has **no additional valid forms**, leave the array empty: `"forms": []`.
> * Use each valid form once; do not duplicate.
> * Apply irregular spellings where necessary (e.g., *run → ran, running*).
> * Output everything in **lowercase**.
> * Output **nothing** except the JSON block.

# Part II

> You are an English–Turkish bilingual vocabulary assistant.
> I will give you **one English word** (written as **{word}**).
> Your task is to list **every distinct meaning** that word can have (separate roots / senses).
> For each meaning, produce an object with the following keys:
>
> * **sentence** – an original B2-level English sentence that naturally uses the word in this meaning.
> * **trSentence** – a precise Turkish translation of *sentence*.
> * **definition** – a clear English definition of this meaning.
> * **partOfSpeech** – the word’s part of speech *as it appears in your sentence* (e.g. *noun*, *verb*, *adjective*).
>
> Return everything as **valid JSON** in exactly this structure (no extra keys, no markdown):
>
> ```json
> {
>   "meanings": [
>     {
>       "sentence": "",
>       "trSentence": "",
>       "definition": "",
>       "partOfSpeech": ""
>     }
>     // …repeat for each additional meaning
>   ]
> }
> ```
>
> Use a separate object for each distinct meaning.
> Do not add commentary outside the JSON.

---

# Part III

> **How to use**
>
> 1. Replace **{word}** with your target word (e.g. *“set”*).
> 2. Paste the whole prompt into ChatGPT.
> 3. ChatGPT returns the JSON with all meanings, example sentences, Turkish translations, definitions, and parts of speech.
> 
> You are my English word-family dictionary for IELTS preparation.
> 
> TASK  
> When I give you a single base word (e.g. <YOUR WORD>), return **only** a valid JSON object in the exact schema below.  
> Do not add explanations, headings or extra keys.
> 
> SCHEMA
> ```json
> {
>   "wordFamilies": [
>     {
>       "word": "",          // family member (root or derived form)
>       "partOfSpeech": "",  // noun, verb, adjective, adverb, etc.
>       "sentence": "",      // one natural B2-level example
>       "trSentence": "",    // Turkish translation of that sentence
>       "definition": ""     // concise English meaning used in the sentence (≤ 20 words)
>     }
>   ]
> }
> ```
> 
> RULES  
> 1. Include only forms that a B2–C1 learner is likely to meet (avoid obscure or archaic items).  
> 2. Each English sentence must be original, 10–20 words, and showcase the given word clearly.  
> 3. Provide an accurate Turkish translation; keep grammar natural.  
> 4. Keep the JSON strictly valid (double quotes, commas in correct places, no comments).  
> 5. Output nothing except the JSON object.


Example Usage:

```json
{
"root": "scissor",
"forms": [
"scissors",
"scissored",
"scissoring",
"scissorer",
"scissory",
"scissorless",
"unscissor"
],
"meanings": [
{
"sentence": "The tailor picked up a sharp scissor to trim the loose threads.",
"trSentence": "Terzi, gevşek iplikleri düzeltmek için keskin bir makas aldı.",
"definition": "a single cutting tool consisting of two pivoted blades; a pair of scissors",
"partOfSpeech": "noun"
},
{
"sentence": "She scissored the photograph into a perfect circle for her art project.",
"trSentence": "Sanat projesi için fotoğrafı mükemmel bir daire şeklinde makasla kesti.",
"definition": "to cut something using scissors",
"partOfSpeech": "verb"
},
{
"sentence": "The dancers scissored their legs rhythmically as they crossed the stage.",
"trSentence": "Dansçılar sahneyi geçerken bacaklarını ritmik olarak makasladı.",
"definition": "to move parts of the body so they cross and separate like the blades of scissors",
"partOfSpeech": "verb"
},
{
"sentence": "The wrestler caught his rival in a tight scissor and won the match.",
"trSentence": "Güreşçi, rakibini sıkı bir makasa alarak maçı kazandı.",
"definition": "a wrestling hold in which the legs are wrapped around an opponent's body or head",
"partOfSpeech": "noun"
}
],
"wordFamilies": [
{
"word": "scissors",
"partOfSpeech": "noun",
"sentence": "The chef reached for his kitchen scissors to neatly trim the fresh herbs.",
"trSentence": "Şef, taze otları düzgünce kesmek için mutfak makasını aldı.",
"definition": "a cutting tool consisting of two crossing blades"
},
{
"word": "scissor",
"partOfSpeech": "verb",
"sentence": "He carefully scissored the colored paper into stars for the class decoration.",
"trSentence": "Sınıf süslemesi için renkli kağıdı yıldız şeklinde dikkatlice makasla kesti.",
"definition": "to cut something using scissors"
},
{
"word": "scissoring",
"partOfSpeech": "noun",
"sentence": "Constant scissoring of the fabric kept every strip exactly two centimeters wide.",
"trSentence": "Kumaşın sürekli makaslanması her şeridi tam iki santimetre genişliğinde tuttu.",
"definition": "the act of cutting repeatedly with scissors"
},
{
"word": "scissored",
"partOfSpeech": "adjective",
"sentence": "The invitation's scissored edges gave it a delicate, handmade appearance.",
"trSentence": "Davetiye'nin makasla kesilmiş kenarları ona zarif, el yapımı bir görünüm verdi.",
"definition": "cut out or shaped with scissors"
}
]
}
```

STAY AWAY FROM SENTENCES THAT REPEAT EACH OTHER.
