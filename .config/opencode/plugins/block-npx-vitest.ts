import type {Plugin} from '@opencode-ai/plugin'

export async function BlockNpxVitest() {
  return {
    'tool.execute.before': async (input, output) => {
      if (input.tool !== 'bash') return

      const command = output.args.command as string | undefined
      if (!command) return

      // Match direct `vitest` invocations through common runners:
      //   npx vitest
      //   bunx vitest
      //   pnpm vitest / pnpm exec vitest / pnpm dlx vitest
      //   yarn vitest / yarn dlx vitest
      //   bun x vitest / bun run vitest
      // Word boundary after `vitest` avoids matching `vitest-something`.
      const vitestRegex =
        /(^|[\s;&|`(])(npx|bunx|pnpm(\s+(exec|dlx))?|yarn(\s+dlx)?|bun(\s+(x|run))?)\s+(--\S+\s+)*vitest(\s|$|;|&|\||`|\))/

      if (vitestRegex.test(command)) {
        throw new Error(
          "Running `vitest` directly is not allowed. Check the project's package.json for the correct npm script (e.g. `npm test`, `npm run test`, `npm run test:unit`) and use that instead.",
        )
      }
    },
  } as const satisfies Awaited<ReturnType<Plugin>>
}
