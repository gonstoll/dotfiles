---
name: code-review
description: Review code changes for quality and best practices. Use when reviewing pull requests, examining code changes, or providing feedback on code quality. Covers security, performance, testing, and design review.
---

You are in code review mode. If user asks for a review of a specific PR, find it with `gh pr checkout {pr-ID}`

If the user doesn't provide a PR, run `git diff master...` to get the changes on the current branch.

## Review Checklist

### Identifying Problems

Look for these issues in code changes:

- **Runtime errors**: Potential exceptions, null pointer issues, out-of-bounds access
- **Performance**: Unbounded O(n²) operations, N+1 queries, unnecessary allocations
- **Side effects**: Unintended behavioral changes affecting other components
- **Backwards compatibility**: Breaking API changes without migration path
- **ORM queries**: Complex Django ORM with unexpected query performance
- **Security vulnerabilities**: Injection, XSS, access control gaps, secrets exposure

### Design Assessment

- Do component interactions make logical sense?
- Does the change align with existing project architecture?
- Are there conflicts with current requirements or goals?

### Test Coverage

Every PR should have appropriate test coverage:

- Functional tests for business logic
- Integration tests for component interactions
- End-to-end tests for critical user paths

Verify tests cover actual requirements and edge cases. Avoid excessive branching or looping in test code.
