---
name: avoid-ai-writing
description: Strip AI-sounding writing patterns (promotional language, vague attribution, litotes, filler vocabulary, formulaic structure, formatting tics) from prose before it ships. USE WHEN writing or reviewing artifacts, documentation, reports, PR/commit descriptions, or any response with more than a couple paragraphs of original prose. Adapted from Wikipedia's "Signs of AI writing".
version: 1.0.0
---

# Avoid AI writing

A checklist for catching writing that reads as machine-generated. The underlying problem is
usually inflated confidence or padding; the vocabulary is only the symptom.

## 1. Litotes and negative parallelism: the most common tell

Don't state a claim by negating its opposite, and don't lean on "not X, but Y" as a rhetorical
crutch. Say the thing directly.

- Bad: "This isn't uncommon." → Good: "This happens often."
- Bad: "The fix wasn't without complications." → Good: "The fix had complications."
- Bad: "It's not just a bug fix, but a fundamental rework." → Good: "It's a fundamental rework, not a bug fix."
- Bad: "Not a coincidence: it's computed from..." → Good: "It's computed from..." (state the causal claim, drop the throat-clearing negation in front of it)
- Bad: "X rather than Y" used in every other sentence as a hedge → Good: pick the direct claim; use contrast constructions only when the contrast itself is the point, and vary the phrasing.

One instance is fine. Three on a page is a tic.

## 2. Prefer plain "is"

Don't reach for "serves as," "stands as," "functions as," "represents," "boasts," "features"
in place of a plain "is" or "has." They exist to dodge a repeated "is," and readers are fine
with a repeated "is."

- Bad: "The dashboard serves as the primary interface for the team."
- Good: "The dashboard is the team's primary interface."

## 3. Cut inflated vocabulary

Three habits with one root: reaching for a word that sounds like it means something.

Promotional adjectives, the kind a travel brochure runs on: *vibrant, rich, profound,
showcases, renowned, nestled, in the heart of, groundbreaking, diverse array, cutting-edge,
game-changing, seamless, robust, holistic, world-class, best-in-class, unparalleled,
revolutionize*. If a sentence would fit in a brochure, rewrite it as a claim you could
footnote.

- Bad: "This unlocks a powerful, seamless workflow for teams."
- Good: "This lets a team run the report without switching tools."

Asserted significance standing in for demonstrated significance: *stands/serves as a testament,
plays a crucial/pivotal role, underscores the importance of, marks a turning point, represents
a paradigm shift, has far-reaching implications, cements its place*. If something is important,
say what it does and let that carry the weight. Don't also announce that it's important.

Filler that pads without adding content: *additionally, delve, crucial, intricate, pivotal,
tapestry, garner, enduring, align with, enhance, foster/fostering, highlight/highlighting,
leverage, navigate, landscape (as in "the X landscape"), ecosystem (for anything that isn't
literally an ecosystem), journey (for anything that isn't literally a trip), unlock, empower,
elevate, streamline, multifaceted, nuanced*. Any one is fine alone; a cluster of them signals
padding. Notice if you're reaching for more than one or two per paragraph. Same for the stock
openers: *"In today's fast-paced world," "In the ever-evolving landscape of X," "At the end of
the day," "It's worth noting that," "Needless to say."* Just say the thing the sentence is
about to say.

## 4. Don't attribute claims to nobody

Avoid *industry experts say, some critics argue, observers have noted, many believe, studies
show* without naming the expert, critic, observer, or study. If you don't have a specific
source, either say the claim plainly as your own assessment (and flag it as such) or don't
make it.

## 5. Don't tack on unsupported interpretation with "-ing" phrases

Avoid appending a vague interpretive clause to a factual statement: *"...highlighting its
importance," "...underscoring the need for," "...reflecting a broader trend," "...ensuring
long-term success," "...fostering collaboration."* If the interpretation is real, argue it as
its own sentence with actual support. If it isn't, cut it; the fact usually doesn't need the
editorial gloss.

- Bad: "The team shipped the feature in two weeks, highlighting their strong execution."
- Good: "The team shipped the feature in two weeks." (If execution speed is the point, say why it mattered, concretely.)

## 6. Don't default to triplets

Don't reach for triplets by default (*"fast, reliable, and scalable"; "clear, concise, and
correct"*). Use the number of items the content actually has: one, two, four, whatever it is.
A triplet is fine when there really are three things; it's a tell when every list in a
document happens to have exactly three items.

## 7. Don't write a formulaic conclusion

Avoid closing a section or response with a summary that just restates what was already said,
especially the "Despite challenges, X continues to Y" or "Overall, X represents..." shape.
End on the last real point. If the response is long enough that a reader genuinely needs a
summary, make it earn the space: give a decision or a next step.

## 8. Formatting tics that read as generated

- **Bold**: use it for genuine emphasis, not on every key term in a paragraph.
- **Em dashes**: fine occasionally; more than one or two per paragraph reads as a tic. Prefer
  a period, comma, or colon when one of those does the job.
- **Emoji as decoration**: don't add emoji to headers or bullets to "liven up" text the user
  didn't ask to be livened up.
- **Title Case Headers**: use sentence case ("Why this failed") unless the surrounding
  document's convention is title case.
- **Bullet-itis**: don't convert two related sentences into a two-item bulleted list by
  reflex. Prose is often the better format for anything with connective reasoning between
  points; reach for bullets when the items are genuinely parallel and scannable.
- **Unnecessary horizontal rules or section dividers**: don't add a divider before every
  heading if the document doesn't already use that convention.

## 9. Don't pad the response itself

- No throat-clearing ("Great question!", "I'd be happy to help with that!", "Sure, here's...").
- Don't restate the user's question before answering it.
- Don't narrate what you're about to do in filler terms ("Let's dive into..."); just do it, or
  state the concrete next action.
- Don't add a trailing summary that just repeats the body when the response is short enough
  that the user can just re-read it.

## 10. The positive check

After a draft, look for the marks of writing that carries its weight:
- Plain "is"/"are" instead of a synonym.
- A specific number, name, or example instead of a vague category ("payers return roughly 30
  cents per billed dollar" beats "payers often reimburse a limited portion").
- Sentences of varying length; not every sentence is a clean, medium-length declarative.
- A claim that could be wrong, stated plainly instead of hedged into meaninglessness.
- Cutting a sentence entirely when it doesn't add new information, even if it "sounds nice."

## How to apply this

Write the draft, then re-read it once against this list before sending or publishing. Context
decides. A document about tapestries is allowed to use the word "tapestry," and a single
litotes is ordinary human writing. Act on the stacks: three negated claims on a page, a
promotional adjective in every paragraph, every list landing on exactly three items. When a
line trips the check, cut it or rewrite the claim; swapping in a synonym leaves the padding
in place.

## Not this skill

- Not a grammar or spell-checker; it targets tone and padding, not correctness.
- Not a style guide for code comments; see the repo's own conventions for those.
