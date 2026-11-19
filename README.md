# roblox-workflow

Плагин Claude Code: правила работы над игрой в Roblox Studio (`CLAUDE.md`) и команды. Подходит для любой игры — название и id `/setup` берёт из открытой Studio по MCP.

| Команда | Что делает |
|---|---|
| `/setup` | берёт название, placeId, universeId игры из Studio (MCP), создаёт `CLAUDE.md`, кладёт `tools/chat-extract.ps1` (повторный запуск — обновление) |
| `/total` | сводка чата в `Chat/latest.md` (по полной переписке на диске, по частям) |
| `/new [название]` | сводка + новый чат `<название>_chat_verN` в той же папке, с правилами и сводкой; старые чаты проекта — в архив (остаётся один) |

Если имя команды занято другим скиллом — полное имя: `/roblox-workflow:new` и т.п.

## Установка (один раз)
В Claude Code (вкладка Code в приложении Claude):
```
/plugin marketplace add JIuC0HbKa/roblox-workflow
/plugin install roblox-workflow@roblox-workflow
```
Репозиторий приватный — нужен доступ к нему на GitHub и вход в git на этом компьютере.

Потом открыть игру в Studio (MCP включён), открыть сессию в папке проекта (одна папка на игру) и выполнить `/setup`.

## Обновление
```
/plugin marketplace update roblox-workflow
```
затем `/setup` в папке проекта (обновит `CLAUDE.md`).

## Личное
`CLAUDE.local.md` в папке проекта — личные правила, в репозиторий не попадают и /setup их не трогает.

Требования: Windows (PowerShell), приложение Claude (Code) — `/new` запускает новую сессию через него.
