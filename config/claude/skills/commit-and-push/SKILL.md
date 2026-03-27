---
name: commit-and-push
description: Groups local changes into relevant commits with conventional commit messages, then pushes. Use when user asks to commit, push, or ship local changes.
---

# Commit and Push

## Process

1. **Check branch** - if on trunk (`main`/`master`), create a descriptive branch first:
   ```bash
   git checkout -b <type>/<short-description>
   ```

2. **Review all changes**:
   ```bash
   git status
   git diff
   ```

3. **Group and commit** - stage related changes together, one commit per concern:
   ```bash
   git add <relevant files>
   git commit -m "<type>(<scope>): <short description>"
   ```

4. **Push**:
   ```bash
   git push
   ```

## Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). Keep messages short and informative.

| Type | Use for |
|---|---|
| `feat` | New feature |
| `fix` | Bug fix |
| `chore` | Tooling, config, maintenance |
| `refactor` | Restructuring without behaviour change |
| `docs` | Documentation only |
| `test` | Tests only |
| `perf` | Performance improvement |

**Format:** `type(optional-scope): imperative description`

**Good:** `fix(auth): handle expired token on refresh`
**Bad:** `fixed some stuff with tokens`

Use `<type>!(<scope>)` for breaking changes.

**Format:** `feat!(config): replace JSON with YAML configuration`

## Rules

- Never commit directly to trunk - always branch first
- One commit per logical concern - split unrelated changes
- No fixup commits - get it right the first time
- Scope is optional but useful for larger repos
