---
name: elements-of-style
description: Apply Strunk's rules of usage and composition — active voice, positive form, concrete language, omitting needless words, parallel construction, emphatic word order — to make prose clear and forceful while drafting or revising. USE WHEN writing or reviewing artifacts, documentation, reports, PR/commit descriptions, or any response with more than a couple paragraphs of original prose. Companion to avoid-ai-writing: that skill strips bad tics after the fact, this one builds sound sentences and paragraphs from the start. Adapted from Strunk's "The Elements of Style" (1918, public domain).
version: 1.0.0
---

# Elements of Style

Rules for building clear, forceful sentences and paragraphs, condensed from William
Strunk's *The Elements of Style* (1918). Where `avoid-ai-writing` is a checklist for
stripping bad patterns out of a draft, this skill is about the construction underneath:
apply these while composing, not just while proofreading.

## 1. Active voice

Prefer the active voice; it is more direct and vigorous than the passive.

- Bad: "My first visit to Boston will always be remembered by me."
- Good: "I shall always remember my first visit to Boston."

The passive is not banned — use it when the sentence is genuinely about what was
done to something, not who did it ("The dormitories were built in 1970," in a
paragraph about the dormitories). But watch for two passive-voice tells that read
as padding:

- **A passive depending on another passive.** "He has been proved to have been seen
  entering the building" → "It has been proved that he was seen to enter the building."
- **A noun that already names the action, doing the verb's job.** "A survey of this
  region was made in 1900" → "This region was surveyed in 1900." "Confirmation of
  these reports cannot be obtained" → "These reports cannot be confirmed."

Also replace `there is`/`there were`/`could be heard` constructions with a real verb:
"There were a great number of dead leaves lying on the ground" → "Dead leaves
covered the ground."

## 2. Positive form

State what is, not what is not. Use `not` for genuine denial or antithesis, never
as a way to avoid committing to a claim.

- Bad: "He was not very often on time." → Good: "He usually came late."
- Bad: "The Taming of the Shrew is rather weak in spots... Bianca [does not] remain
  long in memory as an important character." → Good: "Katharine is disagreeable,
  Bianca insignificant."

Prefer the direct negative word over `not` + weak positive: *dishonest* over "not
honest," *forgot* over "did not remember," *ignored* over "did not pay any attention
to." This is the same failure mode `avoid-ai-writing` §1 calls out as litotes — the
underlying fix is identical: say the thing, don't negate its opposite.

## 3. Concrete, specific, definite language

Prefer the specific to the general, the definite to the vague, the concrete to the
abstract.

- Bad: "A period of unfavorable weather set in." → Good: "It rained every day for a week."
- Bad: "He showed satisfaction as he took possession of his well-earned reward." →
  Good: "He grinned as he pocketed the coin."

A reader's attention is held by specifics — a number, a name, a mechanism — not by
a category standing in for them. This is `avoid-ai-writing`'s "positive check":
"payers return roughly 30 cents per billed dollar" over "payers often reimburse a
limited portion." When a sentence names a category instead of the instance, ask
what the instance actually is and write that.

## 4. Omit needless words

Every word should tell. Cut the padding phrases that dress up a plain idea:

| Padded | Plain |
|---|---|
| the question as to whether | whether |
| there is no doubt but that | no doubt |
| he is a man who | he |
| owing to the fact that | since, because |
| in spite of the fact that | though, although |
| the fact that he had not succeeded | his failure |
| His brother, who is a member of the same firm | His brother, a member of the same firm |

Also collapse a chain of short sentences that step through one idea into a single
sentence that states the relation directly:

- Bad (six sentences): "Macbeth was very ambitious. This led him to wish to become
  king of Scotland. The witches told him that this wish of his would come true..."
- Good: "Encouraged by his wife, Macbeth achieved his ambition and realized the
  prediction of the witches by murdering Duncan and becoming king in his place."

`the fact that`, `who is`/`which was` as connective tissue, and stepwise sentence
chains are the constructional version of what `avoid-ai-writing` §3 calls filler
vocabulary — the fix here is structural (delete or recast), not a vocabulary swap.

## 5. Parallel construction for parallel ideas

Give expressions of similar content and function similar outward form, so the reader
recognizes the likeness without re-parsing it.

- Bad: "Formerly, science was taught by the textbook method, while now the laboratory
  method is employed."
- Good: "Formerly, science was taught by the textbook method; now it is taught by
  the laboratory method."

Correlatives (*both...and, not...but, either...or, first...second...third*) must be
followed by the same grammatical construction on both sides:

- Bad: "It was both a long ceremony and very tedious." → Good: "The ceremony was
  both long and tedious."
- Bad: "My objections are, first, the injustice of the measure; second, that it is
  unconstitutional." → Good: "My objections are, first, that the measure is unjust;
  second, that it is unconstitutional."

Varying the form on purpose, mid-list, doesn't read as style — it reads as
indecision. This is the mirror image of `avoid-ai-writing` §6 (don't force a triplet):
if a list has three genuinely parallel items, make them parallel in form; don't pad
a list to three, and don't drop the parallel form when the count is right.

## 6. Keep related words together

Put the subject and its verb next to each other unless a genuine parenthetical or
relative clause belongs between them. Put a relative pronoun immediately after its
antecedent, and a modifier immediately next to what it modifies.

- Bad: "Wordsworth, in the fifth book of *The Excursion*, gives a minute description
  of this church." → Good: "In the fifth book of *The Excursion*, Wordsworth gives
  a minute description of this church."
- Bad: "He only found two mistakes." → Good: "He found only two mistakes." (These
  say different things; pick the one you mean.)

## 7. Put the emphatic word at the end (or, deliberately, at the start)

The end of a sentence is where a reader's attention naturally lands the hardest;
put the point you want remembered there, not buried mid-sentence ahead of a
qualifier that trails off.

- Weaker: "Humanity has hardly advanced in fortitude since that time, though it has
  advanced in many other ways."
- Stronger: "Humanity, since that time, has advanced in many other ways, but it has
  hardly advanced in fortitude."

This is also why a formulaic closing restates the wrong thing: if the last sentence
of a section is a generic recap, the reader's attention lands on the recap, not on
your actual conclusion. See `avoid-ai-writing` §7 — the fix there (end on the real
point, not a summary) is this rule applied to a whole section instead of one sentence.

## 8. One paragraph, one topic

Make the paragraph the unit of composition. Start it with a topic sentence when the
piece is expository or argumentative; let every sentence after that develop or
support it; end on the paragraph's real point, not a digression or an aside.

A paragraph made entirely of same-shaped compound sentences — clause, conjunction,
clause, conjunction, clause — reads as monotonous regardless of content. Vary
sentence length and structure: some short declaratives, some sentences with a
subordinate clause, occasionally a longer periodic sentence that holds the main
point until the end for suspense.

## 9. Words often misused, still worth watching for

A short list of habits Strunk singled out that still show up in generated and
hastily written prose:

- **`case`, `character`, `nature`, `factor`, `feature`** as padding nouns: "acts of
  a hostile character" → "hostile acts"; "was the great factor in his winning" →
  "he won by being better trained."
- **`the fact that`**, **`due to`** misused for *because of*, **`along these lines`**,
  **`in connection with`** — recast the sentence rather than swap in a synonym.
- **`certainly`, `very`, `so`** as an intensifier reached for by reflex ("so good,"
  "so delightful") — cut it, or replace with a word strong enough to not need it.
- **`one of the most`** as an essay opener ("Switzerland is one of the most
  interesting countries of Europe") — threadbare by construction; say what's
  actually interesting about it.
- **`however`** at the head of a sentence, meaning *nevertheless* — move it inward:
  "The roads were bad. At last, however, we reached camp," not "However, we at
  last reached camp."

## Where this differs from `avoid-ai-writing`

Both target the same failure — inflated, padded, imprecise prose — from opposite
ends:

- `avoid-ai-writing` is a **post-hoc filter**: read a finished draft and strike
  specific tics (litotes, promotional adjectives, unsupported "-ing" clauses,
  formatting habits).
- `elements-of-style` is **constructional**: apply these rules while composing, so
  the sentence is built right the first time and there's less to strike afterward.

Use both. Draft with these rules in mind, then run the `avoid-ai-writing` checklist
before shipping — it catches the vocabulary-level tics that survive even a
well-constructed sentence.

## Not this skill

- Not a comprehensive grammar reference; it covers Strunk's rules of usage and
  composition, not the full range of English grammar.
- Not a citation or spelling authority — Strunk's spelling and misused-word lists
  (Chapters V-VI of the original) are mostly omitted here except where still
  common; see the source text for the complete list.
- Doesn't cover code comments or identifier naming; see the repo's own conventions
  for those.

## Attribution and license

Adapted from William Strunk Jr., *The Elements of Style* (1918/1920 editions),
Project Gutenberg EBook #37134. The original is in the public domain in the United
States (published before 1923); this adaptation condenses and rewords its rules
and examples for prose review rather than reproducing the text verbatim. The
repository's MIT license applies to this file's surrounding structure and any
original wording; Strunk's underlying public-domain text carries no license
restriction of its own.
