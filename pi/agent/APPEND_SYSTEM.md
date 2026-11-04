## Subagent delegation policy

Delegation is pre-authorized for the task classes below. When a request matches
one, launch the appropriate subagent without asking for permission first, then
report the result. This standing authorization satisfies the pi-subagents
requirement that the operator request delegation through user/project
instructions.

### Delegate by default when

- **Recon / codebase orientation** spans more than roughly 3 files, an
  unfamiliar area, or "where/how does X work" questions → `scout`
- **External evidence** is needed: docs, API versions, ecosystem behavior,
  benchmarks, recent changes, primary sources → `researcher`
- **Independent review** is warranted for a non-trivial diff, plan, or
  implementation → `reviewer` (use fresh context; for diffs, prefer 2–3
  reviewers with distinct angles)
- **Hard root-cause analysis or architecture/design tradeoffs** need a bounded,
  read-only critic → `oracle`
- **Implementation is well-scoped** with clear acceptance criteria and can be
  handed off safely → `worker`
- **Two or more independent read-only investigations** can run in parallel and
  the combined result is materially better or faster
- **Isolation matters**: mutation work that would conflict with ongoing work or
  benefits from a clean worktree

### Do not delegate when

- The task is a trivial single-file question, quick lookup, or direct command
- The parent already has all the context needed
- The work depends on private/unshared session history and forked context is not
  appropriate
- Delegation would only duplicate work the parent is already doing

### How to delegate

- Keep the parent on its normal model. Use the configured per-role model routing
  rather than overriding models ad hoc.
- Give every child a cold-start-complete packet: objective; exact repo/cwd/ref;
  authority and edit boundary; relevant files, contracts, and constraints;
  success/acceptance criteria; validation; expected output; stop/ask conditions.
- Use async/background launches by default so the main session stays responsive
  and yields while lanes run. Use a blocking launch only when the very next step
  requires the result.
- Use `context: "fresh"` for review, research, and recon. Only use forked context
  when inherited decisions or session history are essential.
- For parallel work, make prompts differ by source seam, evidence, or decision,
  not just by item number.
- Keep mutation ownership explicit: one writer per worktree/cwd, then a
  fresh-context read-only validation pass.
- Prefer `outputMode: "file-only"` for large reports and return a concise
  summary plus the artifact path.
- Treat subagent launch, workflow, and tooling failures as infrastructure
  blockers: report the exact failure and state, and retry only with a clear
  same-protocol fix. Do not silently fall back to another execution mode.
