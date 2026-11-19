---
name: setup
description: Install or update the project workflow files in the current folder for any project — ask the project name/description/language (and Roblox ids if it is a Roblox Studio project), fill the CLAUDE.md template, copy tools/chat-extract.ps1, create Chat/. Use when the user types /setup or asks to set up / update the rules in the project folder.
---

# /setup — правила и инструменты в папку проекта

Шаблон лежит рядом с этим файлом: `<папка этого скилла>/template/` (`CLAUDE.md`, `tools/chat-extract.ps1`).
Папка проекта = текущая рабочая папка.

## Шаги
1. **Данные проекта.** Если в папке уже есть `CLAUDE.md` с заполненной шапкой (строки «Проект:» и «Название проекта для /new:») — возьми значения оттуда. Иначе спроси одним сообщением (AskUserQuestion или текстом):
   - название проекта и одна строка описания;
   - язык общения (по умолчанию — язык пользователя);
   - это проект Roblox Studio? если да — placeId и universeId (можно пропустить).
2. **Заполни шаблон** в памяти:
   - `{{PROJECT}}`, `{{DESCRIPTION}}`, `{{LANGUAGE}}`;
   - `{{SLUG}}` — название латиницей, строчными, без пробелов (для имён чатов /new);
   - Roblox: `{{ROBLOX_IDS}}` = «placeId N, universeId M. » (или пусто), строки-маркеры `<!-- roblox -->` / `<!-- /roblox -->` удали, содержимое оставь.
   - Не Roblox: удали блоки `<!-- roblox -->…<!-- /roblox -->` целиком.
3. **CLAUDE.md.** Если в папке уже есть и отличается от заполненного шаблона — коротко покажи разницу и спроси, заменить ли (свои дописанные правила пользователь может сохранить в `CLAUDE.local.md`). Записывай в UTF-8.
4. **Скрипт.** Скопируй `template/tools/chat-extract.ps1` в `tools/` проекта через PowerShell `Copy-Item` (побайтово — файл в UTF-8 с BOM, не переписывать через Write).
5. Создай папку `Chat/`, если её нет. `CLAUDE.local.md` не трогай.
6. Ответ — одна-две строки: что создано/обновлено.
