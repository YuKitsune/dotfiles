# Claude Code

## 1. Writing

- 1.1 Write all text in ASD-STE100 Simplified Technical English (STE). This includes code comments, exception messages, documentation, pull requests, and issues.

## 2. Git and GitHub

- 2.1 Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) only if the repository uses them already.
- 2.2 Commit to a branch. Ask first if you must commit to the trunk (main or master).
- 2.3 Use the `gh` CLI for GitHub operations.
- 2.4 Keep commit messages, pull requests, issues, and review comments short. Give a high-level summary. Give the details only if the user asks for them.
- 2.5 Use a pull request template or an issue template only for a complex change. For other changes, write one or two short paragraphs.

## 3. Workflow

- 3.1 After you write code, do not run builds, tests, or linters. Wait for instructions.
- 3.2 If the requirements are ambiguous, ask the user for clarification.
- 3.3 At the end of each plan, make a list of the open questions.
- 3.4 Write only what the user asks for. If you find a possible improvement, or a problem with performance, security, usability, or maintainability, tell the user. Make the change only if the user approves.
- 3.5 If there are important trade-offs, give two or more solutions. Give the advantages and the disadvantages of each solution.

## 4. Code

- 4.1 Write simple code that shows its intent. Do not use clever abstractions or hidden behavior.
- 4.2 Use composition. Use inheritance only if composition is not possible.
- 4.3 Keep your code consistent with the patterns of the codebase.
- 4.4 When you remove code, remove it fully. Do not add comments about the removed code.
