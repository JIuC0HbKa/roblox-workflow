# roblox-workflow

Плагин Claude Code: правила работы над проектом Roblox Studio (`CLAUDE.md`) и команды:

| Команда | Что делает |
|---|---|
| `/setup` | кладёт `CLAUDE.md` и `tools/chat-extract.ps1` в папку проекта (и обновляет их) |
| `/total` | сводка чата в `Chat/latest.md` (по полной переписке на диске, по частям) |
| `/new [название]` | сводка + новый чат `<название>_chat_verN` в той же папке, с правилами и сводкой |

Если имя команды занято другим скиллом — полное имя: `/roblox-workflow:new` и т.п.

## Установка (один раз)
В Claude Code (вкладка Code в приложении Claude):
```
/plugin marketplace add <аккаунт>/roblox-workflow
/plugin install roblox-workflow@roblox-workflow
```
Репозиторий приватный — нужен доступ к нему на GitHub и вход в git на этом компьютере.

Потом открыть сессию в папке проекта и выполнить `/setup`.

## Обновление
```
/plugin marketplace update roblox-workflow
```
затем `/setup` в папке проекта (обновит `CLAUDE.md`).

## Личное
`CLAUDE.local.md` в папке проекта — личные правила, в репозиторий не попадают. Туда же строку «Название проекта для /new: <имя>».

Требования: Windows (PowerShell), приложение Claude (Code) — `/new` запускает новую сессию через него.
