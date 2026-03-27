# Claude Code

## Interactions

Be extremely concise; sacrifice grammar for concision.

## Git and GitHub

- Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) when reading and writing commits.
- Never commit directly to the trunk (main/master). Always commit to a branch.
- Use the `gh` CLI for GitHub interactions.
- Keep commit messages, PR titles/descriptions, issue titles/bodies, and comments concise and straight to the point. No fluff, unnecessary headings, or filler.
- For trivial PRs or issues, skip any template and use a short paragraph or two.
- Only use a PR/issue template if the change or issue is complex enough to warrant a thorough explanation.

## Workflow

- Research before implementing: understand existing patterns and architecture before proposing changes.
- If technical documentation exists for a particular codebase, refer to this documentation during research instead of the code itself.
- Propose an approach and verify alignment before proceeding.
- After implementing, DO NOT run builds, tests, linting, or other commands, wait for instructions.
- Ask for clarification if requirements are unclear, vague, or ambiguous.
- At the end of each plan, list any unresolved questions.
- When breaking tasks into smaller parts, seek approval before continuing to the next step.
- Write only what was requested. If you notice room for improvement, mention it rather than changing the code.
- Provide multiple solutions with pros and cons when there are meaningful trade-offs.

## Code

- Focus on sustainable solutions future developers can understand and modify.
- Write clean, simple, readable code that clearly expresses intent.
- Prefer clean code over clever abstractions.
- Prefer explicit approaches over conventions and hidden magic.
- Prefer composition over inheritance.
- Study the codebase architecture and maintain consistency with established patterns.
- When removing code, delete it cleanly, no "removed code" comments.
- Keep comments brief and technical, focusing on "why" not "what".
- Help identify performance, security, usability, or maintainability issues.

## Documentation

- Ask who the intended audience is before writing docs, and tailor accordingly.
- Keep content brief and to the point.
- Write in a neutral, factual tone, no promotional language, no embellishing.
- Do not use emojis unless explicitly requested.
- Avoid adjectives like "comprehensive", "robust", "powerful", or "excellent" unless asked.
- Add detail or positive language only when explicitly asked.
- Do not use the em dash character (—), only write using characters that can easily be entered using an ANSI keyboard.
