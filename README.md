# IDE-Shepherd Hook Test

This repository is purely for **security testing purposes**.

It simulates the behavior of the DPRK Contagious Interview / TaskJacker malware campaign, which abuses git hooks (`.husky/pre-commit`) to download and execute secondary payloads.

This repository **does NOT contain actual malware**. The `pre-commit` hook in this project attempts to download and execute harmless mock scripts (`payloads/linux.sh` or `payloads/windows.bat`) that simply print a message and list a few processes.

The primary goal of this repository is to test and validate the detection capabilities of the `IDE-SHEPHERD-extension` against malicious Git hook modifications.
