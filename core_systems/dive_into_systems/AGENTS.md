# Dive Into Systems Summary Workflow

This directory stores a locally maintained `SUMMARY.md` for the book *Dive Into Systems*.

The goal is not to write a loose synopsis. The goal is to create a structured study summary that preserves the book's original instructional artifacts while making the material easier to review locally.

## Scope

- `SUMMARY.md` is the main output.
- `media/` stores all locally downloaded images referenced by `SUMMARY.md`.
- Work proceeds one subsection at a time unless the user explicitly asks for a larger batch.

## Source Of Truth

- The source content is the live book at `https://diveintosystems.org/book/`.
- Each subsection in `SUMMARY.md` must be checked against the corresponding source page before being considered complete.
- Do not rely on earlier summaries if they conflict with the source page.

## What Must Be Preserved

For each completed subsection, preserve all of the following from the source page:

- headings in the same order
- images
- figure captions
- code blocks
- shell command blocks
- output blocks
- admonition / aside / warning text blocks

Do not selectively keep only "important" blocks. If the source subsection has a block-like instructional artifact, keep it.

## Allowed Adaptation

The summary may include short connective prose, but it must not disrupt or reorder the original instructional flow.

Allowed:

- short overview sentence at the start of a subsection
- local image paths instead of remote image URLs
- markdown heading normalization where needed to keep hierarchy readable

Not allowed:

- dropping source blocks
- merging separate source blocks into one block unless they are already presented together in the source
- changing the order of headings, figures, or blocks
- replacing original examples with paraphrases

## Heading Rules

Match the book's heading hierarchy as closely as practical in Markdown.

Current convention:

- chapter title: `##`
- top subsection title like `1.1. ...`: `###`
- numbered nested subsection like `1.1.1. ...`: `####`
- smaller in-page labels like `Detailed Steps`, `C Numeric Types`, `Arithmetic Operators`: `######`

Only use `####` for the numbered nested subsection headings that the source clearly presents at that level.

## Code Fence Rules

Use the most accurate fence language for every block:

- C code: ```` ```c ````
- Python code: ```` ```python ````
- shell commands, generic templates, plain output, admonition text: ```` ```text ````

Do not mark C code as `text` when it is actual C syntax.
Do not mark shell/output blocks as `c`.

## Image Rules

- Download every referenced source image into `media/`.
- `SUMMARY.md` must use local relative paths like `![](media/file.png)`.
- Verify the downloaded files are real images, not HTML error pages.
- Some pages use section-local image paths like `/book/C1-C_intro/_images/...` rather than `/book/_images/...`; resolve carefully before downloading.

## Workflow

When adding or fixing a subsection:

1. Inspect the exact source page.
2. Extract headings in order.
3. Extract all images and captions.
4. Extract all code/text/admonition blocks in order.
5. Download any missing images into `media/`.
6. Update only that subsection in `SUMMARY.md`.
7. Verify heading levels, block order, fence languages, and image paths.

If a subsection is incomplete or questionable, prefer deleting the unfinished later subsections rather than leaving inconsistent content in place.

## Current Working Pattern

- The introduction is present.
- Chapter 1 is being rebuilt one subsection at a time.
- Only `1.1. Getting Started Programming in C` should be considered actively curated right now.
- Later subsections should only be added after they are individually checked against the source.

## Editing Principle

Favor exactness over speed.

If there is tension between:

- making the summary shorter
- preserving the source structure and teaching material

choose preservation.
