# Extracts plain dialogue from Claude Code transcripts (.jsonl) for /total summaries.
# Keeps: user messages (without system reminders) + the final assistant text of each turn (trimmed).
# Drops: tool calls/results, images, intermediate narration.
# -Full: from the beginning; otherwise only lines after the offsets saved in state.json.
# Paths are derived from the script location: <project>\tools\chat-extract.ps1 -> <project>\Chat\...
param(
  [string[]]$Transcripts,                       # explicit .jsonl paths (in order); default: current session's .jsonl
  [string]$ProjectDir,                          # Claude Code transcripts dir of the project (default: derived)
  [string]$State,
  [string]$Out,
  [switch]$Full,
  [int]$UserMax = 700,
  [int]$AsstMax = 800
)
$root = Split-Path $PSScriptRoot -Parent
$chat = Join-Path $root "Chat"
if (-not (Test-Path $chat)) { New-Item -ItemType Directory -Force $chat | Out-Null }
if (-not $State) { $State = Join-Path $chat "state.json" }
if (-not $Out) { $Out = Join-Path $chat "extract.txt" }
# Claude Code stores transcripts in ~/.claude/projects/<project path with every non-alphanumeric char as '-'>
if (-not $ProjectDir) { $ProjectDir = Join-Path $env:USERPROFILE (".claude\projects\" + ($root -replace '[^A-Za-z0-9]', '-')) }
if (-not $Transcripts) {
  # актуальный файл = переписка текущей сессии: она пишется прямо сейчас, поэтому самая свежая
  $cur = Get-ChildItem -LiteralPath $ProjectDir -Filter *.jsonl | Sort-Object LastWriteTime | Select-Object -Last 1
  if (-not $cur) { "ERROR: no transcripts in $ProjectDir"; exit 1 }
  if ((Get-Date) - $cur.LastWriteTime -gt [TimeSpan]::FromMinutes(5)) { "ERROR: newest transcript is older than 5 min - pass -Transcripts explicitly"; exit 1 }
  $Transcripts = @($cur.FullName)
}
"source: " + (($Transcripts | ForEach-Object { Split-Path $_ -Leaf }) -join ', ')
$st = @{}
if (-not $Full -and (Test-Path $State)) {
  (Get-Content $State -Raw | ConvertFrom-Json).PSObject.Properties | ForEach-Object { $st[$_.Name] = [int]$_.Value }
}
function Trim([string]$s, [int]$n) {
  $s = ($s -replace '(?s)<system-reminder>.*?</system-reminder>', '' -replace '\s+', ' ').Trim()
  if ($s.Length -gt $n) { $s.Substring(0, $n) + '...' } else { $s }
}
$sb = [System.Text.StringBuilder]::new()
foreach ($t in $Transcripts) {
  $name = Split-Path $t -Leaf
  $start = if ($st.ContainsKey($name)) { $st[$name] } else { 0 }
  $r = [System.IO.StreamReader]::new($t)
  $i = 0; $lastAsst = $null
  while (($line = $r.ReadLine()) -ne $null) {
    $i++
    if ($i -le $start) { continue }
    if ($line -notmatch '"type":"(user|assistant)"') { continue }
    try { $o = $line | ConvertFrom-Json } catch { continue }
    if ($o.isMeta -or $o.isCompactSummary) { continue }
    $c = $o.message.content
    if ($o.type -eq 'assistant') {
      foreach ($b in $c) { if ($b.type -eq 'text' -and $b.text.Trim()) { $lastAsst = $b.text } }
      continue
    }
    $u = if ($c -is [string]) { $c } else { ($c | Where-Object { $_.type -eq 'text' } | ForEach-Object { $_.text }) -join ' ' }
    $u = Trim $u $UserMax
    if (-not $u) { continue }   # tool results only
    if ($lastAsst) { [void]$sb.AppendLine("A: " + (Trim $lastAsst $AsstMax)); $lastAsst = $null }
    [void]$sb.AppendLine("U: " + $u)
  }
  if ($lastAsst) { [void]$sb.AppendLine("A: " + (Trim $lastAsst $AsstMax)) }
  $r.Close()
  $st[$name] = $i
}
[System.IO.File]::WriteAllText($Out, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))
($st | ConvertTo-Json) | Set-Content -LiteralPath $State -Encoding utf8
"chars=$($sb.Length) -> $Out"
