---
name: total
description: Update the compact handoff summary of the chat (done, in progress, to fix, plans, key facts) in <project>/Chat/latest.md — incrementally, from the full on-disk transcript (not the compacted context). Use when the user types /total or asks for a summary/handoff for a new chat.
---

# /total — incremental handoff summary

Project folder = the current working directory (it holds `CLAUDE.md`, `tools/`, `Chat/`). If `tools/chat-extract.ps1` is missing there, tell the user the project isn't set up for /total and stop.
Goal: `Chat/latest.md` always summarizes the WHOLE chat history (all sessions), built from on-disk transcripts, so compaction never loses facts. Each run reads only what is new.

## Steps
1. **Extract the new part:** run `tools/chat-extract.ps1` (PowerShell). It takes the current session's transcript (newest `.jsonl`, written right now), skips what `Chat/state.json` marks as read, writes `Chat/extract.txt` (`U:` user, `A:` my final answer per turn, trimmed). Use `-Full` only if the user asks for a full rebuild.
2. **Read** `Chat/latest.md` (previous summary, may not exist) and `Chat/extract.txt` (delta).
   - delta > ~60k chars: split into parts, give each to a sonnet agent ("terse machine summary: done / decisions / problems_found / open, ≤45 lines, no code, don't invent"), use their outputs.
3. **Merge**: update `done` (newest first), move finished items out of `wip`/`fix`, add new facts; drop stale lines; keep ≤ ~80 lines.
4. **Save** `Chat/latest.md` + copy `Chat/total-YYYY-MM-DD-HHmm.md`; keep only the 10 newest `total-*.md`.
5. **Reply** in the user's language, one line: path + «в новом чате: «прочитай Chat/latest.md»». Don't paste the summary.

## Format (terse English / key=value; omit empty sections)
```
# total <date>
proj: <name, ids>
env: <key scripts/folders/tools, quirks>
ver: <last saved / last published version>
done: <newest first, 1 line each, with versions>
wip: <started, not finished — exact next step>
fix: <known bugs / complaints not fixed>
plan: <agreed next tasks / postponed ideas>
facts: <decisions, limits, gotchas — what does NOT work and why>
```
No code dumps, no private data, don't repeat CLAUDE.md rules.
