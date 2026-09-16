# package.json Rules

## Requirements

- **Must contain** the current repository name in the `name` field (e.g., `github-action-template`)
- **Must contain** a description of the repository in the `description` field
- Defines all project dependencies and development tools
- Contains scripts for common tasks: `npm ci`, `npm test`, `npm run build`, `npm run release`
- Version field is automatically updated by semantic-release during releases
- Locked dependency versions are maintained in `package-lock.json`
