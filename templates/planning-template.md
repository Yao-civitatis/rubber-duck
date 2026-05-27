# Spec-Driven Implementation Plan: {JIRA_KEY}

## 1. Traceability (Spec-Driven)
- **Current US:** [Link to JIRA]
- **Branch:** `feature/{JIRA_KEY}` or `bugfix/{JIRA_KEY}`
- **Evolves/Modifies:** [None | E.g. CIVI-123] *(If this task alters previous behavior, link it here)*
- **Dependencies:** [Resolved]
- **Target Module/Bounded Context:** `{project}.{module}`

## 2. ⚠️ Defensive Planning (Just-in-Time)
- **Assumptions:** [Assumptions for the current scenario]
- **Questions:** [Doubts or clarifications needed for the current scenario]

## 3. Architectural Pre-flight Check
- [ ] Layer isolation rules respected.
- [ ] Shared DTOs used for cross-module communication (no internal entities leaked).
- [ ] YAGNI check: No premature abstractions or redundant object mapping planned.

## 4. Execution (STRICT LIMIT: ONE SCENARIO AT A TIME)
*Planner rule: ONLY expand the FIRST pending scenario. Leave the rest as "[Pending Planning]".*

**Language rule for this template:**
- Write all sections in English.
- Keep IDs and code literals as-is (Jira keys, X-Ray IDs, symbols, commands).

### 🟢 ACTIVE SCENARIO: [Gherkin Scenario 1 / X-Ray ID]
**Criteria:** *Given [X] When [Y] Then [Z]*
**First Test Confirmation:** `required` *(options: `required` | `skipped` — default: `required`)*

- [ ] **SCENARIO TEST MATRIX (Mandatory):** Define the complete checklist of tests required to validate this scenario end-to-end within this codebase.
  - [ ] `T1` [Unit/Integration/Observability] [X-Ray: XRAY-KEY-1]: [Expected behavior or contract]
  - [ ] `T2` [Unit/Integration/Observability] [X-Ray: XRAY-KEY-2]: [Expected behavior or contract]
  - [ ] `T3` [Unit/Integration/Observability] [X-Ray: XRAY-KEY-3]: [Expected behavior or signal]
- [ ] **TRACEABILITY CHECK:** Every matrix item must declare its X-Ray ID and must map to at least one automated test implementation. One X-Ray ID may be covered by multiple tests.
- [ ] **RED:** Pick the next pending matrix item. Write exactly one automated test for it. Ensure it FAILS. **MUST include X-Ray ID in test code.**
- [ ] **GREEN (Domain):** [List core domain classes/functions to create/modify]
- [ ] **GREEN (Application/UI):** [List use cases, controllers, or adapters to create/modify]
- [ ] **REFACTOR & OBSERVE:** Clean code (small functions). Add required metrics/logs.
- [ ] **SCENARIO COMPLETENESS GATE:** Repeat RED -> GREEN -> REFACTOR until every matrix item is implemented and passing.
- [ ] **COMMIT:** `feat({JIRA_KEY}): implement scenario 1`

### ⏳ PENDING SCENARIO: [Gherkin Scenario 2]
*-- [Pending Planning] --*
