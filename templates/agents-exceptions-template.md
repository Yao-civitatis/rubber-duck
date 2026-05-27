# AGENTS.md — Project-Level AI Agent Configuration

## Known Exceptions

Exceptions listed here are acknowledged deviations from the standard rules. The `/audit` command reads this section and **notifies** when an exception is applied, but does not fail the audit for these items.

Only add exceptions that affect code **already in the codebase** and are not part of the current active scenario. New code must always comply with all rules.

| Rule | Scope | Reason | JIRA Debt |
|------|-------|--------|-----------|
| `max-method-lines` | `com.example.OrderService.legacyProcess()` | Legacy method pending refactor | [CIVI-456](https://jira.example.com/browse/CIVI-456) |
| `layer-isolation` | `reports` module | Temporal coupling approved in ADR-012 | — |

### Column Definitions

- **Rule:** The rule identifier being excepted (e.g., `max-method-lines`, `layer-isolation`, `api-uri-conventions`).
- **Scope:** The specific class, method, module, or file path where the exception applies.
- **Reason:** Brief justification for the exception.
- **JIRA Debt:** Link to a technical debt ticket if one exists. Leave `—` if not applicable.

### Guidelines

- Exceptions apply only to **pre-existing code**, never to code introduced in the current scenario.
- Remove exceptions when the underlying issue is resolved.
- The `/audit` command will report all applied exceptions in its output for transparency.
