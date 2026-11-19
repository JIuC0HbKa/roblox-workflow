---
name: setup
description: Install or update the Roblox workflow files in the current project folder for whatever game is open in Roblox Studio — read the game name, placeId and universeId via Roblox Studio MCP, fill the CLAUDE.md template, copy tools/chat-extract.ps1, create Chat/. Use when the user types /setup or asks to set up / update the rules in the project folder.
---

# /setup — правила и инструменты в папку проекта

Шаблон лежит рядом с этим файлом: `<папка этого скилла>/template/` (`CLAUDE.md`, `tools/chat-extract.ps1`).
Папка проекта = текущая рабочая папка (одна папка на одну игру).

## Шаги
1. **Данные игры.**
   - Если в папке уже есть `CLAUDE.md` с заполненной шапкой (строка «Проект: игра «…»» с placeId) — возьми значения оттуда.
   - Иначе — из Studio по MCP: `list_roblox_studios` → placeId, universeId (несколько Studio — спроси, какая игра). Название: `execute_luau` (Edit) `return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name` (не опубликована / ошибка — `game.Name`).
   - Studio не подключена — попроси открыть игру в Studio (и включить MCP) или назвать игру; id тогда «не указан».
   - Язык общения — язык пользователя.
2. **Заполни шаблон:** `{{GAME}}`, `{{PLACE_ID}}`, `{{UNIVERSE_ID}}`, `{{LANGUAGE}}`, `{{SLUG}}` — название латиницей, строчными, без пробелов (для имён чатов /new). Покажи пользователю одной строкой, что подставлено.
3. **CLAUDE.md.** Если в папке уже есть и отличается от заполненного шаблона — коротко покажи разницу и спроси, заменить ли (свои дописанные правила можно держать в `CLAUDE.local.md`). Запись в UTF-8.
4. **Скрипт.** Скопируй `template/tools/chat-extract.ps1` в `tools/` проекта через PowerShell `Copy-Item` (побайтово — файл в UTF-8 с BOM, не переписывать через Write).
5. Создай папку `Chat/`, если её нет. `CLAUDE.local.md` не трогай.
6. Ответ — одна-две строки: что создано/обновлено.
