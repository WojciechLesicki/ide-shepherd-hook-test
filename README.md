# IDE-Shepherd Hook Test

This repository is purely for **security testing purposes**.

It simulates the behavior of the DPRK Contagious Interview / TaskJacker malware campaign, which abuses git hooks (`.husky/pre-commit`) to download and execute secondary payloads.

This repository **does NOT contain actual malware**. The `pre-commit` hook in this project attempts to download and execute harmless mock scripts (`payloads/linux.sh` or `payloads/windows.bat`) that simply print a message and list a few processes.

The primary goal of this repository is to test and validate the detection capabilities of the `IDE-SHEPHERD-extension` against malicious Git hook modifications.

## Bundled extension (local build)

A packaged build of IDE Shepherd is included for manual testing:

- `extensions/ide-shepherd-extension-3.1.4.vsix` — branch `feature/detect-git-hooks`: opt-in advisory flag, dedup modals, dual-signal hook content, trusted workspace skip, IOC `precommit.vercel.app`, detection-only modal (Dismiss / Remove hook / Trust workspace)

**Before installing:** uninstall any older IDE Shepherd build (`Extensions` → search “IDE Shepherd” → Uninstall), then install this VSIX and reload the window.

### Enable git-hook advisory (required)

From v3.1.4 the workspace scan is **opt-in** (default off, upstream-friendly):

1. Settings → search `gitHookAdvisory` → enable **Git Hook Advisory**, **or** in `settings.json`:

   ```json
   "ide-shepherd.gitHookAdvisory.enabled": true
   ```

2. **Developer: Reload Window**

### Install

From this repository root:

```bash
code --install-extension extensions/ide-shepherd-extension-3.1.4.vsix
```

Or with Cursor:

```bash
cursor --install-extension extensions/ide-shepherd-extension-3.1.4.vsix
```

Reload the window, enable advisory (above), reload again, then **File → Open Folder** on this repo. You should get a webview security modal for `.husky/pre-commit` immediately (before `npm install` or `git commit`).

### Expected result

- **On folder open** (with advisory enabled): static scan flags `.husky/pre-commit` (wget/curl pipe-to-shell pattern). Modal title: `Malicious Git Hook Detected`; body explains **detection only** (not an extension block), CTI context, and three buttons: **Dismiss alert**, **Remove malicious hook**, **Ignore & Allow**.
- **With advisory disabled (default):** no git-hook modal on folder open.
- **After `npm install`:** `prepare` sets `core.hooksPath` to `.husky` (legitimate Husky — should **not** alert on `.git/config` alone).
- **On `git commit`:** hook can still run the mock payload in git/terminal — static scan does not block commits; runtime extension hooks may block network/process activity from extensions depending on configuration.
- **After Trust this workspace:** reopening the folder should **not** show the git-hook modal again (security event may still be logged).
