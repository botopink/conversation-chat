# conversation-chat

The written conversation between the machines that build botopink and its maintainer. Nothing here is a
decision: a decision lives in `specs/1.0.12-beta/decisions-taken.md` of the meta repository (`botopink/projects`),
and a question in its `decisions-pending.md`. This repository keeps the exchanges that lead there — the status
reports, the blocking factors, the answers, the decision digests — so that each side can read what the other
said without a chat window.

## Who writes where

| Directory | Who writes | What |
|---|---|---|
| `machine-1/` | machine 1 (checker, the library fronts, 165) and the maintainer's replies to it | one file per day, `YYYY-MM-DD.md` |
| `machine-2/` | machine 2 (backends, std, tooling, 164, 166) and the maintainer's replies to it | one file per day |
| `machine-3/` | machine 3, when it exists, and the maintainer's replies to it | one file per day |
| `all/` | the maintainer, to every machine at once (a decision digest, a rule) | one file per day |

## The shape of an entry

Entries are appended, newest last; the time is the machine's local time. Nothing of an entry is edited after it is written but its check.

```markdown
### [ ] 23:40 — machine 2 → maintainer
Done:      …
Running:   …
Next:      …
Blocking:  …

### [x] 23:55 — maintainer → machine 2
…
```

Every entry opens with a check. The writer leaves it `[ ]`; the reader, the side the arrow points at, turns it
into `[x]` when it has read the entry, and commits that — the one edit ever made to what the other side wrote.
An entry in `all/` carries three checks, one per machine in order — `### [ ] [ ] [ ] 00:35 — maintainer → all` —,
and each machine turns its own into `[x]`. `scripts/unread.sh [machine-1|machine-2|machine-3|maintainer]` lists the
entries addressed to a side that it has not checked yet (exit 1 while something is unread); a side reads its
unread entries before it writes.

A report keeps the four lines of `scripts/thread-rules.md` (Done, Running, Next, Blocking) and names every
blocking factor — a pending question, another machine's hash, the pool. A reply answers each factor or says
what still waits and on whom. Hashes are welcome here (this is a log, not a spec); scratch paths (`.tasks/…`,
`/tmp/…`) are not.

## Rules

- English, like every file of the project.
- Append; never rewrite what the other side already read. The reader checks (`[x]`) each entry addressed to it when it reads it, and commits the check.
- A commit per entry or per batch of entries, `chat(machine-2): report 23:40` / `chat(all): decisions 664–666`,
  pushed to `feat` at once (`main` follows `feat`). No branches, no PRs, no hooks.
- The meta repository pins this one under `repository/conversation-chat`; the pointer is bumped when it is
  convenient, never a condition for a message.
