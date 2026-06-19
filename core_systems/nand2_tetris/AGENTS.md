# Nand2Tetris Workspace Notes

## Purpose

This folder tracks study progress through "The Elements of Computing Systems" (Nand2Tetris) using hand-maintained learning notes:

- `NOTES.md`: subsection-by-subsection notes (book + slides + video transcripts).
- `projects/`: one Markdown file per project containing HDL solutions and explanations.
- `DFF_DEEP_DIVE.md`: supplemental explanation of feedback, latches, flip-flops, and the DFF abstraction.
- `slides/`: downloaded lecture slide PDFs.

## Current Progress

- `NOTES.md` contains the ongoing learning notes. Currently finished up to and including **1.3 Hardware Construction**.
- `projects/` currently includes Project 1, Project 2, and Project 3 notes.
- We work subsection-by-subsection and only move on when the current subsection is fully clear.
- Do not jump ahead or bulk-append full-book indexes unless the user explicitly asks for that exact operation.

## `NOTES.md` Style

The notes should read like clear teaching material, not like dense academic notes.

Use this style consistently:

- Move from concrete implementation to abstraction step by step.
- Prefer short paragraphs, explicit examples, and small code/text blocks.
- Explain interfaces with input/control/output meanings.
- Explain behavior with simple rules like `if load = 0: hold` and `if load = 1: store`.
- Use construction ladders such as `DFF -> Bit -> Register -> RAM` when a chapter builds layers.
- Include mental models after technical details when helpful.
- Preserve all headings and relevant image references from the book subsection being covered.
- Do not collapse explanations into vague prose; show how the mechanism works.
- Put implementation links in each chapter's `Project` subsection, and link directly to the exact chip headings inside `projects/`.

## Concrete, Traceable Notes Style

In general (across all chapters), keep the notes in the same style as our Chapter 4 writeup:

- Start with the concrete implementation picture for the subsection: what components/state exist and what the reader should imagine physically (chips, memory, registers, wires, etc.).
- Define the notation early, especially anything that can be misread.
- When a symbol can be interpreted in multiple ways, state the rule for how to disambiguate it in context.
- When showing any code-like snippet (HDL, assembly, pseudocode), follow it immediately with a `Meaning:` block that is line-by-line and explicitly states what changes.
- For figures and program examples, explain by blocks (initialization, loop condition, loop body, increment/jump, termination) and use short pseudocode as a roadmap before diving into snippets.
- Use tiny traces when helpful (one or two iterations, a few key state values) to make pointer-like or stateful behavior concrete.
- Keep `NOTES.md` self-contained: do not add meta lines like `Sources:` or `Slides + transcript emphasis:` inside the notes.

Hack-specific example of the above (only when relevant): `A` and `D` are registers; `M` is not a register, it means `RAM[A]`, and `A` is always one 16-bit value whose interpretation depends on the next instruction.

## Sources

Each subsection in `NOTES.md` is a synthesis of:

- The book: `The_Elements_of_Computing_Systems_2021.md` (source of truth for headings/figures).
- The slides: `slides/lecture-XX.pdf` (reinforces mental models and examples).
- The video course transcript: https://www.youtube.com/watch?v=LqirVc5SlW0&list=PLrDd_kMiAuNmSb-CKWQqq9oBFN_KNMTaI

## Working Rules For Future Agents

1. Work subsection-by-subsection, in order.
2. Preserve existing heading hierarchy and the step-by-step teaching style in `NOTES.md`.
3. Keep image markdown references when they are part of the book subsection being covered. Also add high-quality, value-adding diagrams from the lecture slides (e.g., schematics, interface/implementation splits, simulation GUI callouts, test script comparisons) that map to our text and code snippets.
4. Treat `The_Elements_of_Computing_Systems_2021.md` as the source of truth for headings/figures.
5. Before edits, confirm the exact subsection boundaries in `NOTES.md`.
6. Do not create extra documentation files unless explicitly requested.
7. **Strict Slide Hygiene:** Never add navigation slides (e.g., outlining chapters or dividers like Slide 36), agenda slides, or purely decorative slides. Always view each slide image first to confirm it contains actual educational content.
8. **Balanced Feedback Response:** If a user flags a specific slide as useless or having no value, do not overreact by deleting all slide figures from the section. Carefully review the slide deck, remove only the low-value/redundant slide, and retain or add other slide diagrams that genuinely clarify the text.

## Safety And Scope

- Prefer small, reviewable edits.
- Do not rewrite completed earlier chapters unless asked.
- If user intent is ambiguous (for example, full-book extraction vs incremental continuation), ask first.
