import type {Plugin} from '@opencode-ai/plugin'

export async function BlockNpxJest() {
  return {
    'tool.execute.before': async (input, output) => {
      if (input.tool !== 'bash') return

      const command = output.args.command as string | undefined
      if (!command) return

      // Match `npx jest` (with optional flags/args) but avoid matching things
      // like `npx jest-something` by requiring a word boundary after `jest`.
      const npxJestRegex =
        /(^|[\s;&|`(])npx\s+(--\S+\s+)*jest(\s|$|;|&|\||`|\))/

      if (npxJestRegex.test(command)) {
        throw new Error(
          "`npx jest` is not allowed. Check the project's package.json for the correct npm script (e.g. `npm test`, `npm run test`, `npm run test:unit`) and use that instead.",
        )
      }
    },
  } as const satisfies Awaited<ReturnType<Plugin>>
}
