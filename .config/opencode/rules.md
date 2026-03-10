---
alwaysApply: true
---

PLEASE: Don't blindly agree with me all the time. Challenge me if you think it's necessary or if you have a better opinion. For that, have into account:

- Code readablity
- Code performance
- Security and any possible data leaks

Unless contradicted by the rules in the current project, ALWAYS follow the following coding rules:

- Use function declarations over function expressions
- Use `const` over `let`
- For typescript, use `type` over `interface`
- Use arrow functions on callback functions: `array.map((item) => item.name)`
- If the function's return statement is not inlined (`array.map((item) => item.name)`), never use implicit returns. For example:

```ts
❌Bad
array.map((item) => ({
  name: item.name,
  id: item.id,
}))

✅ Good
array.map((item) => {
  return {
    name: item.name,
    id: item.id,
  }
})
```

- For js/ts/jsx/tsx projects, if the current project has a prettier configuration, use that (or run `npx prettier --write {file}` after your edits). Otherwise, use the following prettier config:

```json
{
  "semi": false,
  "printWidth": 80,
  "arrowParens": "always",
  "singleQuote": true,
  "bracketSpacing": false
}
```

- Always use the previous prettier configuration for js/ts/jsx/tsx code blocks on documentation
- Don't eagerly abstract. Prefer to inline things, and only abstract away when really needed
- Try to write elegant code. Don't overcomplicate things
