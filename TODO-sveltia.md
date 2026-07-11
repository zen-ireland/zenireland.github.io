# TODO: Prototype Sveltia CMS as a TinaCMS replacement

**Goal:** Stand up Sveltia CMS (a modern, actively-maintained, Decap-compatible Git-based CMS) so it can be compared side-by-side with the current TinaCMS admin. Motivation: get a simpler editing front end without Tina's build step / cloud tokens.

## Why Sveltia
- Git-based like Tina: commits Markdown + YAML frontmatter to `_posts/` — right model for this Jekyll static site.
- Actively developed; drop-in compatible with Decap CMS `config.yml`; talks to the GitHub API directly (no separate OAuth backend needed for GitHub auth).
- Removes Tina's overhead: the `tinacms build` step, `TINA_TOKEN`, and `NEXT_PUBLIC_TINA_CLIENT_ID`.
- Alternatives considered: Decap CMS (mature but stagnating UI), Pages CMS (GitHub-only, newer), CloudCannon (paid, Jekyll-first). Sveltia was the pick.

## What to build
A minimal Sveltia admin, typically at `/admin-sveltia/` (keep it separate from Tina's existing `/admin/` so both can coexist for comparison):
- `admin-sveltia/index.html` loading Sveltia CMS.
- `admin-sveltia/config.yml` mapping to the existing content schema (below).
- Make sure Jekyll doesn't strip it (check `_config.yml` include/exclude).

## Exact schema to replicate (from `tina/config.ts`)
Collection: **Posts**, folder `_posts`, one Markdown file per post.
- Filename slug pattern: `YYYY-MM-DD-<slugified-title>.md` (date = today at creation).
- Media: uploads go to `img/`. In posts the `image` field is stored as a root-absolute path, e.g. `image: /img/Lunasa 2026-Poster.jpg`. (Tina config uses `mediaRoot: "img"` with empty publicFolder; sample posts use a leading `/img/`.)

Frontmatter fields (real example from `_posts/2026-06-13-lunasa-sesshin-2026-on-the-aran-islands-2507-0108.md`):
```yaml
title: Lúnasa Sesshin 2026 on the Aran Islands 25/07 - 01/08   # string
date: 2026-06-12T23:00:00.000Z                                 # datetime (ISO)
categories:                                                    # list of strings
  - dublin
  - sesshin
image: /img/Lunasa 2026-Poster.jpg                             # image path
```
- **Body**: Markdown body (Tina field `body`, `isBody: true`).
- **categories** allowed values: `dublin`, `galway`, `sesshin`, `limerick` (select/list widget).
- Some posts may also have `event_date` frontmatter (upcoming events); homepage `index.html` sorts by `event_date`. Consider adding an optional `event_date` datetime field.

## Suggested Decap/Sveltia config.yml sketch
```yaml
backend:
  name: github
  repo: zenireland/zenireland.github.io   # VERIFY org/repo & default branch (master)
  branch: master
media_folder: "img"
public_folder: "/img"
collections:
  - name: posts
    label: Posts
    folder: _posts
    create: true
    slug: "{{year}}-{{month}}-{{day}}-{{slug}}"
    fields:
      - { name: title, label: Title, widget: string }
      - { name: date, label: Date, widget: datetime }
      - { name: categories, label: Categories, widget: select, multiple: true,
          options: [dublin, galway, sesshin, limerick] }
      - { name: image, label: Image, widget: image, required: false }
      - { name: event_date, label: Event date, widget: datetime, required: false }
      - { name: body, label: Body, widget: markdown }
```

## Verification / done criteria
- Load `/admin-sveltia/`, authenticate against GitHub.
- Edit an existing post and create a new one; confirm the committed file matches the existing frontmatter shape and lands in `_posts/` with the right filename.
- Confirm image upload writes to `img/` and the frontmatter path renders on the built site.
- Compare editor UX against Tina and report back.

## Key repo facts
- Jekyll static site, TinaCMS currently at `/admin/`; Tina config: `tina/config.ts`.
- Site URL: https://www.zenireland.com/ ; default branch `master`.
- Build via `just` recipes and a multi-stage Dockerfile (tina-builder stage does `tinacms build`).
