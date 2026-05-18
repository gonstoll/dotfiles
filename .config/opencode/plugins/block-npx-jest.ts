import type {Plugin} from '@opencode-ai/plugin'

export async function BlockNpxJest() {
  return {
    'tool.execute.before': async (input, output) => {
      if (input.tool !== 'bash') return

      const command = output.args.command as string | undefined
      if (!command) return

      // Match direct `jest` invocations through common runners:
      //   npx jest
      //   bunx jest
      //   pnpm jest / pnpm exec jest / pnpm dlx jest
      //   yarn jest / yarn dlx jest
      //   bun x jest / bun run jest
      // Word boundary after `jest` avoids matching `jest-something`.
      const jestRegex =
        /(^|[\s;&|`(])(npx|bunx|pnpm(\s+(exec|dlx))?|yarn(\s+dlx)?|bun(\s+(x|run))?)\s+(--\S+\s+)*jest(\s|$|;|&|\||`|\))/

      if (jestRegex.test(command)) {
        throw new Error(
          "Running `jest` directly is not allowed. Check the project's package.json for the correct npm script (e.g. `npm test`, `npm run test`, `npm run test:unit`) and use that instead.",
        )
      }
    },
  } as const satisfies Awaited<ReturnType<Plugin>>
}
