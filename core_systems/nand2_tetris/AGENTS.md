# Nand2Tetris Workspace Notes

## Purpose

This folder tracks study progress through "The Elements of Computing Systems" (Nand2Tetris) using hand-maintained learning notes:

- `SUMMARY.md`: chapter-by-chapter teaching summary of the book.
- `projects.md`: implementation notes and HDL solutions by project.
- `DFF_DEEP_DIVE.md`: supplemental explanation of feedback, latches, flip-flops, and the DFF abstraction.

## Current Progress

- `SUMMARY.md` is intentionally stopped at Chapter 3 (`3.6 Perspective`).
- Existing `SUMMARY.md` content through Chapter 3 has been rewritten into a step-by-step explanatory style; this is intentional.
- `projects.md` includes Project 1 and Project 2 content.
- Do not jump ahead or bulk-append full-book indexes unless the user explicitly asks for that exact operation.

## `SUMMARY.md` Style

The summary should read like a clear teaching chapter, not like dense academic notes.

Use this style consistently:

- Move from concrete implementation to abstraction step by step.
- Prefer short paragraphs, explicit examples, and small code/text blocks.
- Explain interfaces with input/control/output meanings.
- Explain behavior with simple rules like `if load = 0: hold` and `if load = 1: store`.
- Use construction ladders such as `DFF -> Bit -> Register -> RAM` when a chapter builds layers.
- Include mental models after technical details when helpful.
- Preserve all headings and relevant image references from the source chapter being summarized.
- Do not collapse explanations into vague prose; show how the mechanism works.

## Working Rules For Future Agents

1. Continue summaries incrementally, in order, from the current stopping point.
2. Preserve existing heading hierarchy and the step-by-step teaching style in `SUMMARY.md`.
3. Keep image markdown references when they are part of the chapter content being summarized.
4. Treat `The_Elements_of_Computing_Systems_2021.md` as the source of truth.
5. Before large edits, confirm current stopping point by checking existing headings in `SUMMARY.md`.
6. Do not create extra documentation files unless explicitly requested.

## Safety And Scope

- Prefer small, reviewable edits.
- Do not rewrite completed earlier chapters unless asked.
- If user intent is ambiguous (for example, full-book extraction vs incremental continuation), ask first.
