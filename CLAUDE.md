# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the website for Zen In Ireland / Earth+Sky Zen, a Jekyll-based static site with TinaCMS integration for content management. The site includes a blog with posts about zen events, schedules, and teachings, along with a new site design in development.

## Build & Development Commands

### Jekyll (Current Site)
```bash
# Build the site
bundle exec jekyll build
just jekyll-build

# Build with auto-rebuild on changes
bundle exec jekyll build --watch
just jekyll-build-watch

# Install Ruby dependencies
bundle install
just bundle-install
```

### TinaCMS (Content Management)
```bash
# Development with TinaCMS admin and Jekyll server
npx tinacms dev -c "jekyll serve"
just tina-dev

# Build TinaCMS admin interface
npx tinacms build --skip-search-index --noTelemetry --skip-indexing --skip-cloud-checks
just tina-build
```

### Node.js Dependencies
```bash
# Install Node dependencies (omits optional packages)
npm ci --omit=optional
just npm-ci

# Check for package updates
npx ncu
just ncu

# Update packages
npx ncu -u
just ncuu
```

### Docker
```bash
# Build Docker image
just docker-build

# Build with verbose output
just docker-build-verbose

# Run the container
just docker-run

# Login to GitHub Container Registry
just github-gcr-login
```

### Local Development Server
```bash
# Serve _site directory on port 8000
cd _site && python3 -m http.server 8000
just web-server
```

## Architecture

### Dual Site Structure

The repository maintains two distinct site implementations:

1. **Main Jekyll Site** (root level): The current production website built with Jekyll, using Foundation CSS framework. Content is in `_posts/` as Markdown files with YAML frontmatter.

2. **New Site** (`new_site/`): A redesigned static HTML/CSS site currently in development. Contains modern pages (home.html, about.html, schedule.html, contact.html) with custom styling.

### Content Management

- **TinaCMS Integration**: Provides a visual editor at `/admin` for managing blog posts
  - Configuration in `tina/config.ts`
  - Posts are stored in `_posts/` with date-prefixed filenames
  - Auto-generates slugs from titles using `slugify`
  - Categories: dublin, galway, sesshin, limerick
  - Supports image uploads to `img/` directory

### Jekyll Configuration

- **Posts**: Located in `_posts/` with format `YYYY-MM-DD-title.md`
- **Layouts**: In `_layouts/` (currently just `post.html`)
- **Default Layout**: Posts default to "post" layout with "zen" category
- **Site URL**: https://www.zenireland.com/
- **Plugins**: jekyll-feed, jekyll-seo-tag

### Multi-Stage Docker Build

The Dockerfile uses a multi-stage build process:

1. `ruby-builder`: Base Ruby image with build tools
2. `jekyll-builder`: Builds Jekyll site
3. `node-builder`: Installs Node dependencies
4. `tina-builder`: Builds TinaCMS admin interface
5. `zen-final`: Nginx-based final image combining all assets

Build requires environment variables:
- `TINA_TOKEN`: TinaCMS authentication token
- `NEXT_PUBLIC_TINA_CLIENT_ID`: TinaCMS client ID

### File Organization

- `/img/` - Images and media
- `/_site/` - Jekyll build output (excluded from git)
- `/stylesheets/` - CSS files
- `/js/` - JavaScript (Foundation framework)
- `/new_site_images/` - Images for the new site design
- `/admin/` - TinaCMS admin interface (built by tina-builder)

## Important Notes

- The new site design in `new_site/` is not yet integrated with Jekyll
- Blog posts may contain `event_date` frontmatter for upcoming events
- The homepage (`index.html`) sorts posts by event_date and displays them in reverse chronological order
- Static files (favicon.ico, humans.txt, robots.txt) are copied to the root of the built site
- Jekyll excludes `new_site_images/`, `node_modules/`, `etc/`, and build-related files from processing
