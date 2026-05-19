# IDE-Shepherd Hook Test

This repository is purely for **security testing purposes**.

It simulates the behavior of the DPRK Contagious Interview / TaskJacker malware campaign, which abuses git hooks (`.husky/pre-commit`) to download and execute secondary payloads.

This repository **does NOT contain actual malware**. The `pre-commit` hook in this project attempts to download and execute harmless mock scripts (`payloads/linux.sh` or `payloads/windows.bat`) that simply print a message and list a few processes.

The primary goal of this repository is to test and validate the detection capabilities of the `IDE-SHEPHERD-extension` against malicious Git hook modifications.

## Bundled extension (local build)

A packaged build of IDE Shepherd is included for manual testing:

- `extensions/ide-shepherd-extension-3.0.0.vsix` — built from branch `feature/detect-git-hooks` (git-hook static scan)

### Install

From this repository root:

```bash
code --install-extension extensions/ide-shepherd-extension-3.0.0.vsix
```

Or with Cursor:

```bash
cursor --install-extension extensions/ide-shepherd-extension-3.0.0.vsix
```

Reload the window, then **File → Open Folder** on this repo. You should get a critical alert on `.husky/pre-commit` immediately (before `npm install` or `git commit`).

### Expected result

- **On folder open:** static scan flags `.husky/pre-commit` (wget/curl pipe-to-shell pattern).
- **After `npm install`:** `prepare` sets `core.hooksPath` to `.husky` (legitimate Husky — should **not** alert on `.git/config` alone).
- **On `git commit`:** hook would run the mock payload; runtime hooks may also block network/process activity depending on configuration.
