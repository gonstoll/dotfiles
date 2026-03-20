---
name: write-jira
description: Create a JIRA task through user interview, codebase exploration, and module design
---

This skill will be invoked when the user wants to create a JIRA task. You may skip steps if you don't consider them necessary.

1. Ask the user for a detailed description of the problem they want to solve and any potential ideas for solutions.

2. Explore the repo to verify their assertions and understand the current state of the codebase.

3. Interview the user about every aspect of this plan until you reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.

A deep module (as opposed to a shallow module) is one which encapsulates a lot of functionality in a simple, testable interface which rarely changes.

Check with the user that these modules match their expectations. Check with the user which modules they want tests written for.

4. Run the CLI script to create the JIRA task. Ask the user everything needed for running the CLI script: project, issue type, labels

5. If it's a sub-task, run the CLI so that the user selectes the main story/task/bug

6. Once you have a complete understanding of the problem and solution, use the template below to write the JIRA task. Ask the user if this is a bug, task, sub-task or story. Use the JIRA cli for this (https://github.com/ankitpokhrel/jira-cli), NOT the MCP server.

## Syntax

```bash
jira issue create \
  -p PEAKONLIGHT \
  -t "Sub-task" \
  -P "PEAKONLIGHT-XXXX" \
  -s "Subtask summary" \
  -b "Detailed description" \
  -C "No component" \
  -l "frontend-only"
```

## Key Parameters

- `-p`: Project key (PEAKONLIGHT by default, unless user says otherwise)
- `-t`: Issue type ("Sub-task", "Bug", "Story", "Task")
- `-P`: Parent ticket number (only required for subtasks)
- `-s`: Summary/title
- `-b`: Description (can include newlines)
- `-C`: Component name. If not provided, "No component"
- `-l`: Labels

<jira-template>

## User story

As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## Acceptance criteria

**Scenario #<number>**

Given <scenario-statement>

when <reproduction-statement>

then <expectation-statement>

<acceptance-criteria-example>
Given a customer has raised a customer care ticket to opt out of the new bill system

when the customer care analyst navigates to the dashboard

then at the bottom of the sign up screen, they will see the bill system modal
</acceptance-criteria-example>

## Further Notes

Any further notes about the feature.

</jira-template>
