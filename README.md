# roblox-workflow

Плагин Claude Code: правила работы над проектом (`CLAUDE.md`) и команды. Подходит для любого проекта; для Roblox Studio — дополнительные правила (MCP, режим PLAY).

| Команда | Что делает |
|---|---|
| `/setup` | спрашивает название/описание проекта (и id, если Roblox), создаёт `CLAUDE.md`, кладёт `tools/chat-extract.ps1` (повторный запуск — обновление) |
| `/total` | сводка чата в `Chat/latest.md` (по полной переписке на диске, по частям) |
| `/new [название]` | сводка + новый чат `<название>_chat_verN` в той же папке, с правилами и сводкой |

Если имя команды занято другим скиллом — полное имя: `/roblox-workflow:new` и т.п.

## Установка (один раз)
В Claude Code (вкладка Code в приложении Claude):
```
/plugin marketplace add JIuC0HbKa/roblox-workflow
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
`CLAUDE.local.md` в папке проекта — личные правила, в репозиторий не попадают и /setup их не трогает.

Требования: Windows (PowerShell), приложение Claude (Code) — `/new` запускает новую сессию через него.
