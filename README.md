# homebrew-prebuilt

Formulae that install **official upstream binaries** — no compiling, ever.

For machines running a macOS that Homebrew no longer ships bottles for
(e.g. an Intel Mac stuck on Monterey), a plain core install means building
from source, often via a heavyweight toolchain (rust, go). When the upstream
project publishes official binaries for the platform, this tap wraps them in
a formula so `brew install` keeps working — and what gets installed is the
upstream's own build, unmodified.

## Taxonomy: this tap vs its siblings

The three taps are distinguished by **who built the artifact**:

| Tap | Artifact built by | Versions |
|-----|-------------------|----------|
| [patched](https://github.com/xooooooooox/homebrew-patched) | us (fork + patch, tap CI bottles) | current |
| [legacy](https://github.com/xooooooooox/homebrew-legacy) | Homebrew, historically (ghcr bottle archive) | inherently old — it is an archive |
| **prebuilt** (this tap) | the upstream project | version-agnostic: unsuffixed formulae follow upstream releases; `<tool>@<version>` pinning is possible since upstream release assets persist |

Platform support is orthogonal: each tap does its own delivery work.

## Usage

```bash
brew tap xooooooooox/prebuilt
brew install xooooooooox/prebuilt/<tool>
```

Formula names match homebrew-core (they shadow it, like the patched tap does).

## Tools

| Tool | Upstream binaries | Why here |
|------|-------------------|----------|
| [leaf-markdown-viewer](https://github.com/RivoLink/leaf) | `leaf-macos-{x86_64,arm64}` release assets | entered core 2026-05 — no monterey bottle ever existed; source build needs rust |

## Bumping

Owned by Actions: a weekly schedule livechecks the tap and opens one PR per
outdated formula (new asset urls + sha256s computed by downloading each
asset); merge to accept. GitHub -> Actions -> "bump" -> Run workflow bumps a
single formula on demand (optional version override).
`brew livecheck --tap xooooooooox/prebuilt` works locally too.

## Adding a tool

Only when the upstream publishes official binaries for the platforms that
need it. Copy the leaf formula's shape: arch-aware `on_macos`/`on_intel`/
`on_arm` URLs, `version`, `livecheck`, core-matching `conflicts_with`, and a
real functional test.
