# Claude Code Workflow

TODO: Add common workflows and prompts used with Claude Code.

## Custom Skills

Skills are stored in `config/claude/skills/` and are loaded automatically by the Claude Code harness.

### Grill Me

Skill: `grill-me`

Interviews you relentlessly about a plan or design until reaching shared understanding. Walks down each branch of the decision tree, resolving dependencies one-by-one. Provides a recommended answer for each question.

Example:

```
> /grill-me
# Claude interviews you about your plan, providing recommendations for each decision
```

### Write PRD

Skill: `write-prd`

Creates a PRD through user interview, codebase exploration, and module design. Covers problem statement, user stories, implementation decisions, testing decisions, and out-of-scope items.

Example:

```
> /write-prd
# Claude interviews you about the feature, explores the codebase, and produces a PRD
```

### PRD to Plan

Skill: `prd-to-plan`

Turns a PRD into a multi-phase implementation plan using tracer-bullet vertical slices. Each phase is a thin, end-to-end slice through all layers. Output is saved as a Markdown file in `./plans/`.

Example:

```
# With a PRD already in context:
> /prd-to-plan
# Claude breaks the PRD into vertical slices and saves a plan file to ./plans/
```

### Write Skill

Skill: `write-skill`

Creates new agent skills with proper structure and progressive disclosure. Guides through requirements gathering, drafting, and review.

Example:

```
> /write-skill
# Claude interviews you about the skill, drafts it, and saves it to config/claude/skills/
```

## Domain-Driven Development

Plugin: `ddd@NeoLabHQ/context-engineering-kit`

The DDD plugin implements battle-tested software architecture principles that have proven essential for building maintainable, scalable systems. All principles encoded as rules that include correct and incorrect code examples and added to agent context, during code writing. To add rules to your agent, simply enable plugin

Example:

```
# Rules activate automatically when writing or reviewing code
# Alternatively, you can ask Claude to use DDD directly
> claude "Use DDD rules to implement user authentication"
```

## Test-Driven Development

Plugin: `tdd@NeoLabHQ/context-engineering-kit`

The TDD plugin implements Kent Beck's Test-Driven Development methodology, proven over two decades to produce higher-quality, more maintainable software.
The core principle is simple but transformative: write the test first, watch it fail, then write minimal code to pass.

Example:

```
> claude "implement email validation for user registration"

# Write tests after you made changes
> /tdd:write-tests

# Manually make some changes that cause test failures
> /tdd:fix-tests
```

## Reflection

Plugin: `reflexion@NeoLabHQ/context-engineering-kit`.

The Reflexion plugin implements multiple scientifically-proven techniques for improving LLM outputs through self-reflection, critique, and memory updates.
It enables Claude to evaluate its own work, identify weaknesses, and generate improved versions.

Example:

```
> claude "implement user authentication"
# Claude implements user authentication, then you can ask it to reflect on implementation

> /reflexion:reflect
# It analyses results and suggests improvements
# If issues are obvious, it will fix them immediately
# If they are minor, it will suggest improvements that you can respond to
> fix the issues

# If you would like it to avoid issues that were found during reflection to appear again,
# ask claude to extract resolution strategies and save the insights to project memory
> /reflexion:memorize
```

## Updating Documentation

Plugin: `docs@NeoLabHQ/context-engineering-kit`.

The Docs plugin provides a structured approach to documentation management based on the principle that documentation must justify its existence.
It implements a documentation philosophy that prioritizes user tasks over comprehensive coverage, preferring automation where possible and manual documentation where it adds unique value.

Example:

```
# Install the plugin
/plugin install docs@NeoLabHQ/context-engineering-kit

# Update project documentation after implementing features
> claude "implement user profile settings page"
> /docs:update-docs

# Focus on specific documentation type
> /docs:update-docs api

# Target specific directory
> /docs:update-docs src/payments/
```

## Review

Plugin: `code-review@NeoLabHQ/context-engineering-kit`.

The Code Review plugin implements a multi-agent code review system where specialized AI agents examine code from different perspectives.
Six agents work in parallel: Bug Hunter, Security Auditor, Test Coverage Reviewer, Code Quality Reviewer, Contracts Reviewer, and Historical Context Reviewer.

