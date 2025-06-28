# LEWA!
 - Learn English With AI

<p align="center">
  <img src="https://github.com/user-attachments/assets/708fd5c2-9eef-466a-bf65-9146dea0b2c6" alt="search" width="250" style="margin-right:8px;"/>
  <img src="https://github.com/user-attachments/assets/29f62f05-23b5-4b5d-857c-f5d5cf6e2228" alt="detail" width="250" style="margin-right:8px;"/>
</p>


**Prompt**

> You will receive a single English word **X** that may already be inflected or derived.
> **1.** Identify its **root (base) form**.
> **2.** List every linguistically valid form that can be built from that root using standard English prefixes and suffixes.
> Return your answer **only** in this exact JSON structure (no extra keys, comments, or text):
>
> ```json
> {
>   "root": "<root word here>",
>   "forms": [
>     "<root-s>",
>     "<root-es>",
>     "<root-ed>",
>     "<root-ing>",
>     "<root-er>",
>     "<root-est>",
>     "<root-ly>",
>     "<root-ness>",
>     "<root-ment>",
>     "<root-tion>",
>     "<root-able>",
>     "<root-ible>",
>     "<root-ful>",
>     "<root-less>",
>     "<root-y>",
>     "<root-al>",
>     "<root-ive>",
>     "<root-ist>",
>     "<root-ism>",
>     "<un-root>",
>     "<in-root>",
>     "<im-root>",
>     "<ir-root>",
>     "<dis-root>",
>     "<non-root>"
>   ]
> }
> ```
>
> **Guidelines**
>
> * Include **only** forms that genuinely exist for the root; omit impossible ones.
> * If the root has **no additional valid forms**, leave the array empty: `"forms": []`.
> * Use each valid form once; do not duplicate.
> * Apply irregular spellings where necessary (e.g., *run → ran, running*).
> * Output everything in **lowercase**.
> * Output **nothing** except the JSON block.
