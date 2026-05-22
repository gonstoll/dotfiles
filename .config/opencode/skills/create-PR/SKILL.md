---
name: create-PR
description: Use to create a pull request with detailed summary and description
---

Your job is to create a PR with the current changes.

Ask the user if this is for an existant JIRA ticket, or a new one.

- Follow the template on ./pr-template.md for its content

- For the `## Change` section (`<change-description></change-description>`), make sure to summarize as much as possible the changes. It doesn't need to be technical, just something that describes the overall changes:
  Example: "Parses and validates data on `useQuestionQuery` hook"

- For the `## Problem / Why` section (`<change-reason></change-reason>`), you can get a little bit more technical. Still, it doesn't need to be a huge description, just expanding on what the change is actually like and the reasons behind it.
  Example: "To have types! Even though we are passing it through records (ugh), at some point (one can hope so) we are not going to have the record anymore, and then types are going to be essential"

- If the PR is for an existant JIRA ticket, format the PR title as follows: [<jira ticket id>]: <pr-title></pr-title>

- Once the PR is ready:
  - If the PR is for an existant JIRA ticket, update the `## References` section with the JIRA link. For this:
    - If the user didn't provide the JIRA ticket ID, ask it
    - **DO NOT GUESS THE JIRA TICKET URL**. Use `jira` cli to look for the ticket and understand what is the correct URL
    - Example: `[JIRA ticket ID](Jira URL)

  - If the PR is for a new JIRA ticket:
    - Leave the `## References` section untouched from the template
    - Add the following comment to the PR: `@peakon-bot create-jira PEAKONLIGHT`

- At the end, give the PR URL to the user so that they can open it in the browser easily
