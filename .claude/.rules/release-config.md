# release.config.js Rules

## Requirements

- **Must be** the entry point for semantic-release configuration
- **Must chain** plugins in order: commit-analyzer → release-notes-generator → changelog → git → github
- **Must configure** the assets list (currently `CHANGELOG.md`) to determine what gets committed during release
- **Must include** all branches in the branches list where releases should run (e.g., `main`, release branches)
