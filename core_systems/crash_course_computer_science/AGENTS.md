# AGENTS.md

## Purpose

This folder contains distilled study notes for the Crash Course Computer Science series.

- Primary document: `crash_course_computer_science.md`
- Local media assets: `media/`

Keep edits focused, consistent, and lesson-scoped.

## Current Content Scope

- Lessons 01-06 are already present in `crash_course_computer_science.md`.
- Lesson content uses a repeatable structure and local media references.

## Required Lesson Format

When adding or editing a lesson, follow this structure:

1. `## NN. <Lesson Title>`
2. `Source: [<Video title>](<URL>)`
3. `### Big Picture`
4. Topic subsections as `### ...`
5. `### Core Takeaways`

Use concise bullet points under each subsection.

## Media Rules (Important)

- Use **local files only** from `media/` in markdown references.
- Prefer **online-sourced images persisted locally** (`.png`/`.jpg`) over generating new SVGs.
- Do not leave external hotlinks in lesson body image tags.
- Do not use Obsidian embeds (`![[...]]`) in the final markdown.
- Use standard markdown image syntax: `![Alt text](media/file-name.png)`.
- Keep filenames lesson-scoped and descriptive, for example:
  - `06-gated-latch-circuit.png`
  - `06-ram-addressable-memory-course.png`

If pasted images appear in the vault root (for example `Pasted image ...png`), move them into `media/`, rename clearly, and update the markdown links.

## Editing Conventions

- Keep existing tone: distilled, factual, easy to scan.
- Make sure text and images are coherent together (image appears immediately after the relevant explanation).
- Avoid adding extra sections not requested by the user.
- Unless asked otherwise, only modify the lesson(s) requested by the user.

## Validation Checklist

After every change:

1. Ensure no Obsidian embeds remain: search for `![[`.
2. Ensure all lesson media links resolve (no missing `media/...` files).
3. Ensure no stale references remain to deleted/renamed media.
4. Keep chapter heading/subheading spacing clean (blank line before `###` headers).

## Safety Notes

- Do not revert unrelated user changes.
- Do not rewrite other lessons unless explicitly requested.
- Do not create additional docs in this folder unless requested.
