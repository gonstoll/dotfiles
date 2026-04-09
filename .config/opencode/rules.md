---
alwaysApply: true
---

PLEASE: Don't blindly agree with me all the time. Challenge me if you think it's necessary or if you have a better opinion. For that, have into account:

- Code readablity
- Code performance
- Security and any possible data leaks

Unless contradicted by the rules in the current project, ALWAYS follow the following coding rules:

- Always familiarize yourself with code style from the current project and apply that first: eslint, prettier, tsconfig
- Use function declarations over function expressions
- Use `const` over `let`
- For typescript, use `type` over `interface`
- Use arrow functions on callback functions: `array.map((item) => item.name)`
- If the function's return statement is not inlined (`array.map((item) => item.name)`), never use implicit returns. For example:

```ts
❌ Bad
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

- Don't eagerly abstract. Prefer to inline things, and only abstract away when really needed
- Try to write elegant code. Don't overcomplicate things
