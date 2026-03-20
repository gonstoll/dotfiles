---
name: playwright-generate-test
description: Generate a Playwright test based on a scenario using Playwright CLI
---

# Test Generation with Playwright CLI

Your goal is to generate a Playwright test based on the provided scenario after completing all prescribed steps.

- Ask the user what needs to be tested. {scenario}
- Ask the user where does it need to be tested. {location}

- Once you gathered all that, test {scenario} on {location} using playwright-cli.
- Check playwright-cli --help for available commands.

## Specific Instructions

- DO NOT generate test code prematurely or based solely on the scenario without completing all prescribed steps.
- Save generated test file in the tests directory
- Execute the test file and iterate until the test passes
