---
name: skills-index
description: Index of available Claude skills for this GitHub Action template
metadata:
  type: reference
---

# Skills Index

Reference guide for the core skills in this GitHub Action template repository.

## Available Skills

### 1. [Contribution](./contribution/SKILL.md)

**Category:** Project-specific  
**Description:** Guidelines and workflow for contributing to the project

Covers:

- Development setup and prerequisites
- Branch naming conventions
- Development workflow (from issue to merge)
- Testing and code quality
- Documentation guidelines
- Bug reporting process

**Quick Start:** See [CONTRIBUTING.md](../../CONTRIBUTING.md)

---

### 2. [Package.json](./package-json/SKILL.md)

**Category:** Project-specific  
**Description:** Package.json configuration and requirements

Covers:

- Required fields (name, description, version)
- Dependency management
- Available npm scripts
- Semantic versioning strategy
- Conventional commits integration
- Best practices and troubleshooting

**File:** [package.json](../../package.json)

---

### 3. [README](./readme/SKILL.md)

**Category:** Project-specific  
**Description:** README documentation guidelines and best practices

Covers:

- Essential sections for a good README
- Documentation structure
- Markdown formatting guidelines
- Code examples and usage patterns
- Links and references
- Keeping documentation updated

**File:** [README.md](../../README.md)

---

## Quick Reference Table

| Skill | Purpose | Main File |
| ------- | --------- | ----------- |
| Contribution | Contribution workflow & guidelines | CONTRIBUTING.md |
| Package.json | Dependencies & npm configuration | package.json |
| README | Documentation structure | README.md |

---

## Usage Guide

### For Developers Contributing Code

1. Read [Contribution](./contribution/SKILL.md) skill
2. Follow branch naming and workflow
3. Use conventional commits (`npm run commit`)
4. Ensure all tests pass

### For Managing Dependencies

1. Read [Package.json](./package-json/SKILL.md) skill
2. Use `npm ci` for installation
3. Keep metadata fields accurate (name, description)
4. Use conventional commits for versioning
5. Run security audits regularly

### For Documenting the Project

1. Read [README](./readme/SKILL.md) skill
2. Update [README.md](../../README.md) with:
   - Quick start examples
   - Usage patterns
   - Configuration options
   - Troubleshooting guide
3. Link to related documentation
4. Keep examples working and current

---

## Key Relationships

```text
README.md
├── Links to CONTRIBUTING.md
└── Shows usage examples

package.json
├── Defines version (auto-updated by semantic-release)
├── Defines scripts (including npm run commit)
└── Manages dependencies

CONTRIBUTING.md
├── References package.json scripts
└── References branch naming conventions
```

---

## Best Practices Summary

### Code Quality

✅ Run code review before PRs  
✅ Use conventional commits  
✅ Keep tests passing  
✅ Follow branch naming convention  

### Documentation

✅ Update README with new features  
✅ Keep examples working  
✅ Link related documentation  
✅ Use clear, simple language  

### Automation

✅ Use `npm run commit` for commits  
✅ Let semantic-release manage versions  
✅ Verify workflows pass before merge  
✅ Monitor GitHub Actions runs  

### Security

✅ Use tokens via environment variables  
✅ Keep dependencies updated  
✅ Run security audits  
✅ Validate workflow inputs  

---

## Related Documentation

- [CONTRIBUTING.md](../../CONTRIBUTING.md) — Full contribution guidelines
- [CHANGELOG.md](../../CHANGELOG.md) — Version history and changes
- [LICENSE](../../LICENSE) — Project license

---

## Questions?

- **How to contribute?** → See [Contribution](./contribution/SKILL.md)
- **How to manage deps?** → See [Package.json](./package-json/SKILL.md)
- **How to document?** → See [README](./readme/SKILL.md)

---
