# Global Claude Code Guidelines

## Code Quality Principles

### Core Philosophy

- **Maintainability over cleverness**: Focus on sustainable solutions that future developers (including yourself) can easily understand and modify
- **Simplicity first**: Write clean, simple, readable code that clearly expresses intent
- **Explicit over implicit**: Prefer obvious data flow and clear dependencies over hidden magic

### Naming and Documentation

- **Descriptive names**: Functions and methods should have short but descriptive names that clearly indicate their purpose
- **Self-documenting code**: Code should read like well-written prose; add comments only when the "why" isn't obvious from the "what"
- **Consistent terminology**: Use consistent naming conventions throughout the codebase

### Architecture Principles

- **Direct dependencies** over service locators
- **Small, focused functions** that do one thing well
- **Composition over inheritance** where appropriate
- **Domain-Driven Design**: Prefer DDD patterns when dealing with complex business logic - organize code around business domains, use ubiquitous language, and separate business concerns from technical implementation details
- **Domain model separation**: Keep domain models separate from DTOs, API models, and database entities - use explicit mapping between domain objects and data transfer objects to maintain clean boundaries

## Dependency Management

### Third-Party Libraries

- **Minimal dependencies**: Avoid adding third-party dependencies unless absolutely necessary
- **Evaluate complexity**: Only use external libraries if the requirements are too complex to implement reasonably in-house
- **Example**: Don't import a full frontend framework for basic HTML templating when simple string interpolation suffices
- **Explicit approval**: Only use third-party libraries when explicitly requested or when consulting reveals it's the best approach

### Native Solutions First

- Leverage built-in language features and standard libraries before reaching for external packages
- Consider maintenance burden: every dependency is a potential security risk and maintenance overhead

### External Services

- **In-process over external**: Prefer self-contained, in-process solutions over external services when possible

## Implementation Guidelines

### Scope Management

- **Build only what's requested**: Do not implement additional functionality beyond requirements
- **Consult before expanding**: If you identify opportunities for additional features, discuss them before implementation
- **Clean deletion**: When removing code, delete it cleanly without "removed code" comments

### Code Consistency

- **Follow existing patterns**: Study the codebase architecture and maintain consistency with established patterns
- **Address drift**: If you notice inconsistencies between code, tests, and documentation, consult to determine the correct approach
- **Maintain style**: Match the existing code style, formatting, and conventions

## Testing Strategy

### Test-Driven Approach

- **Always consider testability**: Design code with testing in mind from the start
- **Complex requirements**: Write tests first (TDD) when requirements are complex
- **Simple requirements**: Write code first, then tests, when requirements are straightforward

### Test Quality

- **Small, targeted tests**: Prefer focused unit tests that test specific behaviors
- **Clear test names**: Test names should describe what behavior is being verified
- **Maintainable tests**: Tests should be as clean and maintainable as production code
- **Builder patterns**: Use the builder pattern to construct frequently used types.

## Development Workflow

**Always start with**: "Let me research the codebase and create a plan before implementing."

1. **Research**: Understand existing patterns, architecture, and similar implementations
2. **Plan**: Propose approach and verify alignment before proceeding
3. **Implement**: Use subagents to build the solution
4. **Wait for instructions**: After implementing code changes, do NOT automatically run builds, tests, linting, or git commands - wait for explicit user instructions before continuing

## Problem-Solving Approach

- **Seek clarification** when stuck or uncertain.
- **Ask for help early**: If struggling to find files, tests, or other resources after 1-2 search attempts, ask the user for guidance rather than repeatedly running searches.
- **Simplify** where possible. The simple solution is usually the correct one.
- **Present tradeoffs** when choosing between two approaches.

## Communication Guidelines

### Progress Updates

- Use clear, concise language when describing what you're doing
- Break complex tasks into smaller understandable steps
- Provide context for your decisions

### Asking for Input

- Present specific options rather than open-ended questions
- Explain the trade-offs between different approaches
- Be direct about what you need to proceed
- If necessary, update code comments, documentation, or `CLAUDE.md` with useful context to prevent the same question in future sessions

### Error Handling

- Report errors clearly with relevant context
- Suggest potential solutions when possible
- Ask for guidance when the path forward is unclear
