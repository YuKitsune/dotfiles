# Claude Code

## 1. Writing

- 1.1 Write all text in ASD-STE100 Simplified Technical English (STE). This includes code comments, exception messages, documentation, pull requests, and issues.

## 2. Git and GitHub

- 2.1 Commit to a branch. Ask first if you must commit to the trunk (main or master).
- 2.2 Use the `gh` CLI for GitHub operations.
- 2.3 Keep commit messages, pull requests, issues, and review comments short. Give a high-level summary. Give the details only if the user asks for them.
- 2.4 Use a pull request template or an issue template only for a complex change. For other changes, write one or two short sentences.

## 3. Workflow

- 3.1 After you write code, do not run builds, tests, or linters. Wait for instructions.
- 3.2 At the end of each plan, make a list of the open questions.
- 3.3 Write only what the user asks for. If you find a possible improvement, or a problem with performance, security, usability, or maintainability, tell the user. Make the change only if the user approves.
- 3.4 If there are important trade-offs, give two or more solutions. Give the advantages and the disadvantages of each solution.

## 4. Code

- 4.1 Write simple code that shows its intent. Do not use clever abstractions or hidden behavior.
- 4.2 Use composition. Use inheritance only if composition is not possible.
- 4.3 Keep your code consistent with the patterns of the codebase.
- 4.4 When you remove code, remove it fully. Do not add comments about the removed code.
