---
name: setup
description: Install or update the project workflow files in the current folder — copy CLAUDE.md (rules) and tools/chat-extract.ps1 from this plugin's template, create Chat/. Use when the user types /setup or asks to set up / update the rules in the project folder.
---

# /setup — правила и инструменты в папку проекта

Шаблон лежит рядом с этим файлом: `<папка этого скилла>/template/` (`CLAUDE.md`, `tools/chat-extract.ps1`).
Папка проекта = текущая рабочая папка.

## Шаги
1. Если в папке проекта уже есть `CLAUDE.md` и он отличается от шаблона — коротко покажи разницу и спроси, заменить ли. Не отличается — пропусти.
2. Скопируй `template/CLAUDE.md` и `template/tools/chat-extract.ps1` в папку проекта (PowerShell `Copy-Item`, побайтово — файл в UTF-8 с BOM, не переписывать через Write).
3. Создай папку `Chat/`, если её нет.
4. `CLAUDE.local.md` не трогай. Если его нет — подскажи одной строкой: там личные правила и строка «Название проекта для /new: <имя>».
5. Ответ — одна-две строки: что скопировано.
