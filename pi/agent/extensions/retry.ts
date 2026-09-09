import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const RETRY_CUSTOM_TYPE = "__retry_trigger";

export default function (pi: ExtensionAPI) {
  let pendingRetryCleanup = false;

  pi.registerCommand("retry", {
    description: "Retry the last prompt (use after aborted or errored responses)",
    handler: async (_args, ctx) => {
      if (!ctx.isIdle()) {
        ctx.ui.notify("Agent is still running.", "warning");
        return;
      }

      // Walk the current branch to find the last user message and the
      // assistant response that follows it. We need to strip both from
      // the LLM context so the conversation ends on the user message.
      const branch = ctx.sessionManager.getBranch();
      let lastUserMsg: any = null;
      let assistantAfterUser: any = null;
      let skipPrecedingAssistant = false;

      for (let i = branch.length - 1; i >= 0; i--) {
        const e = branch[i] as any;
        if (e.type !== "message") continue;
        const m = e.message;

        // If we hit an error tool result, skip the preceding assistant
        if (m.role === "toolResult" && m.isError) {
          skipPrecedingAssistant = true;
          continue;
        }

        // Skip assistant messages that errored or were aborted
        if (m.role === "assistant") {
          if (m.stopReason === "error" || m.stopReason === "aborted" || skipPrecedingAssistant) {
            skipPrecedingAssistant = false;
            continue;
          }
        }

        // First user message found (walking backwards)
        if (m.role === "user") {
          lastUserMsg = m;
          // The message immediately before this user message on the branch
          // is the assistant response we want to strip
          for (let j = i - 1; j >= 0; j--) {
            const prev = branch[j] as any;
            if (prev.type !== "message") continue;
            if (prev.message.role === "assistant") {
              assistantAfterUser = prev.message;
              break;
            }
            // Hit another user message before finding an assistant -
            // means the first user had no assistant response yet
            if (prev.message.role === "user") {
              break;
            }
          }
          break;
        }
      }

      if (!lastUserMsg) {
        ctx.ui.notify("No previous message to retry", "warning");
        return;
      }

      const content =
        typeof lastUserMsg.content === "string"
          ? lastUserMsg.content
          : lastUserMsg.content
              .map((c: any) => ("text" in c ? c.text : ""))
              .join("");

      ctx.ui.notify(`Retrying: "${content.slice(0, 80)}${content.length > 80 ? "..." : ""}"`, "info");

      pendingRetryCleanup = true;

      // Send a custom message to trigger a new turn
      pi.sendMessage(
        { customType: RETRY_CUSTOM_TYPE, content: "Retrying.", display: false },
        { triggerTurn: true },
      );
    },
  });

  // Filter out the retry trigger AND everything after the last user
  // message (assistant + tool results) from the LLM context so the
  // conversation ends cleanly on the user message.
  pi.on("context", async (event) => {
    if (!pendingRetryCleanup) return;
    pendingRetryCleanup = false;

    // Find the last user message index
    let lastUserIdx = -1;
    for (let i = event.messages.length - 1; i >= 0; i--) {
      if (event.messages[i].role === "user") {
        lastUserIdx = i;
        break;
      }
    }

    const cleaned = event.messages
      // Remove the custom trigger message
      .filter((msg: any) => msg.customType !== RETRY_CUSTOM_TYPE)
      // Remove everything after the last user message (assistant + tool results)
      .filter((_msg: any, idx: number) => idx <= lastUserIdx);

    return { messages: cleaned };
  });
}
