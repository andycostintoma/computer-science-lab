# Computer Networking Study Workflow

## Purpose

This folder tracks study progress through *Computer Networking: A Top-Down Approach* using one aggregated note stream:

- `NOTES.md`: section-by-section notes that combine the book, course slides, and matching video transcript.

The goal is not to make loose notes. The goal is to preserve the book/course structure while rewriting the material into clearer, easier-to-review explanations.

## Source Material

Book source of truth:

- `Computer_Networking_A_Top-Down_Approach.md`
- `media/`

Course source material:

- YouTube playlist: `https://www.youtube.com/watch?v=74sEFYBBRAY&list=PL1ya5dD_M8uX-BLUF1FEvUNsYWQL5_l0O`
- Local slides under `course/slides/` when available.

The slides directory is intentionally gitignored. Use it as local source material, but do not try to force slides into git unless the user changes that rule.

## Current Progress

- Work proceeds section by section.
- The first active section is `1.1 What Is the Internet?`.
- Do not summarize later sections until the user explicitly asks to move on.
- `NOTES.md` does not exist yet unless created during the current section workflow.

## Notes Rules

When updating `NOTES.md`:

- Preserve the same book headings from the source section, in the same order.
- Preserve every book figure image reference from the source section.
- Preserve figure captions near their figures.
- Integrate the matching course transcript and slide material into the same section notes.
- Treat the book as the structural spine unless the user asks for a different organization.
- Summarize the prose in a friendlier teaching style, similar to `core_systems/nand2_tetris/SUMMARY.md`.
- Prefer short paragraphs, concrete examples, and simple mental models.
- Explain mechanisms step by step instead of compressing them into vague prose.
- Keep technical terms precise: do not oversimplify protocol names, layer names, measurements, or definitions.
- Do not delete source headings just because their content is short.
- Do not add future-section material into the current section.

For section `1.1`, preserve these source headings:

- `#### 1.1 What Is the Internet?`
- `##### 1.1.1 A Nuts-and-Bolts Description`
- `##### 1.1.2 A Services Description`
- `##### 1.1.3 What Is a Protocol?`

Also preserve the figures that appear inside section `1.1`, including their local `media/...` paths.

## Course Source Rules

When using course material for a section:

- Use the matching video transcript from the YouTube playlist.
- Combine the transcript with the matching slide material.
- Treat the transcript as the spoken explanation and the slides as the visual/structural outline.
- Fold course material into `NOTES.md`; do not create a separate course-notes stream unless the user asks.
- Keep notes section-scoped; for now, only work on material corresponding to `1.1`.
- Preserve useful diagrams, examples, and slide terminology when they clarify the section.
- Do not invent transcript content if the transcript cannot be retrieved; state the limitation and use only verified sources.

## Style

Use the same general tone as the Nand2Tetris summary:

- clear teaching prose
- short paragraphs
- explicit examples
- simple lists where they improve scanning
- small text diagrams when they clarify structure
- no dense academic paraphrase

Good pattern:

```text
concrete pieces
  -> what they do
  -> how they connect
  -> why the abstraction matters
```

## Working Rules For Future Agents

1. Confirm the current section before editing.
2. Read the exact source section before writing notes.
3. Update only the requested section.
4. Preserve existing completed sections unless the user asks for revision.
5. Aggregate book, slides, and transcript into one coherent section in `NOTES.md`.
6. Verify image links resolve when adding figures to Markdown.
7. Do not create extra documentation files unless explicitly requested.
8. Do not commit or push unless the user explicitly asks.

## Safety And Scope

- Favor small, reviewable edits.
- If transcript retrieval, slide access, or section boundaries are ambiguous, ask before proceeding.
- Do not rewrite the cleaned source book Markdown as part of summarization unless the user explicitly asks.
- Do not remove or unignore local course assets without explicit user direction.
