---
name: new
description: Hand off the current chat to a fresh Claude Code session in the same project folder: save work, run /total (summary to Chat/latest.md), start a new session named <project>_chat_verN that loads the rules (CLAUDE.md) and the summary and waits for the next task. Use when the user types /new or asks to continue in a new chat.
---

# /new — continue in a new chat

Project folder = the current working directory (holds `CLAUDE.md`, `tools/`, `Chat/`).

## Steps
0. **Unfinished work.** If a task is in progress — finish the current step or stop at a safe point. Save the project the way it is saved (e.g. Roblox Studio connected → `save_place`, NotNeeded = nothing to save; files on disk need nothing). Anything unfinished goes into `wip:` of the summary with the exact next step.
1. **Summary.** Run `tools/chat-extract.ps1` first. If `Chat/latest.md` exists and the delta in `Chat/extract.txt` is empty or trivial (< ~500 chars, nothing project-relevant) — the summary is current: skip the merge (only add the handed-over message to `wip:` if there is one). Otherwise do the rest of the `total` skill. Don't paste the summary into the chat.
   If /new was forced by the context rule, the user's pending message (task or question) goes into `wip:` verbatim-short as «передано: …».
2. **Name.** `Chat/chat-counter.txt` holds the current chat number (default 1); N = +1. Write N back only after step 3 succeeds.
   Project name: the argument after /new, else «Название проекта для /new» from `CLAUDE.local.md`/`CLAUDE.md`, else the project folder name in lowercase. Title `<project>_chat_ver<N>`.
3. **Start the session** with `mcp__ccd_session__start_session` (load via ToolSearch if deferred):
   - initiation `user_asked`, context `fresh`, target `local`, cwd = project folder (absolute path), use_worktree `false`
   - title as above; name = same, lowercase, `_`→`-`, ≤24 chars
   - prompt: «Продолжение работы над проектом. Если правил из `CLAUDE.md` нет в твоём контексте — прочитай `CLAUDE.md` (обязательны). Прочитай `Chat/latest.md` (сводка прошлого чата). Если в `wip:` есть «передано: …» — это сообщение пользователя: обработай его по правилам (вопрос — ответ; задача — план + вопрос по правилу 6). Иначе одной строкой подтверди готовность и жди задачу.»
   - background: «Продолжение проекта из прошлого чата. Правила работы — в CLAUDE.md этой папки (личные — в CLAUDE.local.md), контекст — в Chat/latest.md (сжатая сводка). Отвечай кратко, на языке пользователя.»
4. **Detach** the new session: `mcp__ccd_session_mgmt__detach_session` with its id (otherwise archiving this chat archives it too).
5. **Old chats** — one active chat per project: `mcp__ccd_session_mgmt__list_sessions` → other active sessions titled `<project>_chat_ver*` except the new one → `archive_session` each (reason «/new: старый чат проекта»). Still working / refused — leave it, mention in one line.
6. **Reply**, 1–2 lines: link `[title](#local_<id>)` from the tool result; «этот чат уходит в архив (читать/вернуть — раздел архива в боковой панели)».
7. **Last call of the turn:** `archive_session` with `self` (the conversation ends; nothing may follow). Load the session-mgmt tools via ToolSearch if deferred.

## Rules
- Never start the session before latest.md is written.
- If start_session is refused — say why in one line; the summary is ready for a manual start («прочитай Chat/latest.md»). Archive nothing then.
