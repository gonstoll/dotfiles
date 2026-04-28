import type {Plugin} from '@opencode-ai/plugin'

export async function BlockTsc() {
  return {
    'tool.execute.before': async (input, output) => {
      if (input.tool !== 'bash') return

      const command = output.args.command as string | undefined
      if (!command) return

      // Match direct `tsc` invocations:
      //   tsc
      //   tsc --noEmit
      //   npx tsc
      //   pnpm tsc / pnpm exec tsc
      //   yarn tsc
      //   bunx tsc
      // Word boundary after `tsc` avoids matching `tsconfig`, `tsc-foo`, etc.
      const tscRegex =
        /(^|[\s;&|`(])(npx|bunx|pnpm(\s+exec)?|yarn)?\s*tsc(\s|$|;|&|\||`|\))/

      if (!tscRegex.test(command)) return

      throw new Error(
        "Running `tsc` directly is not allowed. First check the project's `package.json` scripts for one that runs the type check (e.g. `npm run typecheck`, `npm run type-check`, `npm run tsc`) and use that. Only if no suitable script exists may you run `tsc` directly — in that case, include a brief note explaining why no script was used.",
      )
    },
  } as const satisfies Awaited<ReturnType<Plugin>>
}
