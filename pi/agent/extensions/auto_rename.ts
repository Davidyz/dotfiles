import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

/**
 * Auto-rename sessions via the `session_rename` tool.
 *
 * The tool description nudges the model to call `session_rename` on the
 * first turn. If it does, the name is persisted via
 * `sessionManager.appendSessionInfo()`.
 *
 * The model can also call it mid-conversation if the goal pivots, or
 * Pass null or omit to leave it unchanged.
 * Pass an empty string to also leave it unchanged.
 */

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "session_rename",
    label: "Rename Session",
    description:
      "Set or clear the display name of the current session. " +
      "Use a concise phrase or short sentence that describes the session's goal. " +
      "You should call this on the first turn to name the session. " +
      "You may also call it mid-conversation if the goal pivots. " +
      "Pass null or omit to leave the name unchanged. " +
      "Pass a non-empty string to set a new name.",
    parameters: Type.Object({
      name: Type.Optional(
        Type.String({
          description:
            "The new session name, or omit to leave it unchanged.",
        }),
      ),
    }),
    async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
      const currentName = ctx.sessionManager.getSessionName();
      const newName = params.name;

      if (newName === undefined || newName === "" || newName === currentName) {
        return {
          content: [
            {
              type: "text",
              text: `Session name is "${currentName ?? "(none)"}" — no change made.`,
            },
          ],
          details: {},
        };
      }

      ctx.sessionManager.appendSessionInfo(newName);

      return {
        content: [
          {
            type: "text",
            text: `Session renamed to "${newName}".`,
          },
        ],
        details: {},
      };
    },
  });
}
