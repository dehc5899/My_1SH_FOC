# slx-textconv.ps1  -  git "textconv" helper for Simulink .slx files
#
# git calls:   powershell ... -File slx-textconv.ps1 <path-to-temp-copy-of-the.slx>
# and diffs whatever this script prints to stdout.  The .slx is a zip (OPC package);
# we print every XML/JSON part as text, sorted, each under a header line that
# also shows the Simulink path of the subsystem / Stateflow chart it belongs to.
# Before every block a comment line with the full Simulink path of the block is
# inserted; git uses it as the "@@ ... @@ <path>" hunk header (see xfuncname).
# Volatile "UI state" lines (window positions, open/closed flags, last-saved time,
# editor scroll position, monitor size ...) are NOT printed, so a save without a
# real edit gives an empty diff.  This script never changes the .slx file.
param([Parameter(Mandatory = $true)][string]$Path)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

# ---- parts that are never printed (binary / pure UI state) -------------------
$skipParts = @(
    '^metadata/thumbnail\.png$',
    '^simulink/windowsInfo\.xml$',        # editor window geometry, zoom, scroll, dock layout
    '^\[Content_Types\]\.xml$'
)
# ---- lines that are dropped before diffing (regex per part) ------------------
$volatile = @(
    @{ Part = '^metadata/coreProperties\.xml$'; Line = '<dcterms:modified' },
    @{ Part = '^simulink/systems/system_.*\.xml$'; Line = '^\s*<P Name="WindowPosition">' },
    @{ Part = '^simulink/systems/system_.*\.xml$'; Line = '^\s*<P Name="Open">(on|off)</P>\s*$' },
    @{ Part = '^simulink/stateflow/chart_.*\.xml$'; Line = '^\s*<P Name="(windowPosition|viewLimits|screen|visible)">' },
    @{ Part = '^simulink/stateflow/chart_.*\.xml$'; Line = '^\s*<subviewS/>\s*$' }
)

function Read-Text($entry) {
    $sr = New-Object System.IO.StreamReader($entry.Open(), (New-Object System.Text.UTF8Encoding($false)), $true)
    try { return $sr.ReadToEnd() } finally { $sr.Dispose() }
}

$zip = [System.IO.Compression.ZipFile]::OpenRead((Resolve-Path -LiteralPath $Path).Path)
$sb = New-Object System.Text.StringBuilder
try {
    $entries = @($zip.Entries | Where-Object { $_.Name -ne '' })

    # ---- map "system_N.xml" -> Simulink path, by following <System Ref="system_N"/> --
    $parentOf = @{}     # 'system_77' -> @{ Parent='system_root'; Block='Clarke-Park-...' }
    foreach ($e in ($entries | Where-Object { $_.FullName -like 'simulink/systems/system_*.xml' })) {
        $self = [IO.Path]::GetFileNameWithoutExtension($e.Name)
        $lastBlock = ''
        foreach ($l in ((Read-Text $e) -split "`r?`n")) {
            if ($l -match '^  <Block BlockType="[^"]*" Name="([^"]*)"') { $lastBlock = $Matches[1] }
            elseif ($l -match '^    <System Ref="(system_\d+)"') { $parentOf[$Matches[1]] = @{ Parent = $self; Block = $lastBlock } }
        }
    }
    function Get-SysPath($sys) {
        if ($sys -eq 'system_root' -or -not $parentOf.ContainsKey($sys)) { return '<model>' }
        $p = $parentOf[$sys]
        return (Get-SysPath $p.Parent) + '/' + $p.Block
    }

    foreach ($e in ($entries | Sort-Object { $_.FullName })) {
        $name = $e.FullName
        if ($skipParts | Where-Object { $name -match $_ }) { continue }

        $sysPath = ''
        $label = $name
        if ($name -match '^simulink/systems/(system_\d+|system_root)\.xml$') {
            $sysPath = Get-SysPath $Matches[1]
            $label = "$name   [$sysPath]"
        }

        $isText = $name -match '\.(xml|json|rels|txt|m)$'
        if (-not $isText) {
            $ms = New-Object System.IO.MemoryStream
            $s = $e.Open(); $s.CopyTo($ms); $s.Dispose()
            $sha = [System.Security.Cryptography.SHA1]::Create().ComputeHash($ms.ToArray())
            [void]$sb.Append("<!-- ##### $label -->`n<binary part, $($e.Length) bytes, sha1 " + (($sha | ForEach-Object { $_.ToString('x2') }) -join '') + ">`n")
            continue
        }

        $lines = (Read-Text $e) -split "`r?`n"
        $rules = @($volatile | Where-Object { $name -match $_.Part })
        if ($name -like 'simulink/stateflow/chart_*.xml') {
            $lines | Where-Object { $_ -match '<P Name="name">(.*)</P>' } | Select-Object -First 1 | ForEach-Object { $label = "$name   [chart " + $Matches[1] + "]" }
        }
        [void]$sb.Append("<!-- ##### $label -->`n")
        $prevDropped = $false
        foreach ($l in $lines) {
            $drop = $false
            foreach ($r in $rules) { if ($l -match $r.Line) { $drop = $true; break } }
            # '<P Name="Visible">on</P>' directly after a dropped WindowPosition line belongs to it
            if (-not $drop -and $prevDropped -and $l -match '^\s*<P Name="Visible">(on|off)</P>\s*$') { $drop = $true }
            $prevDropped = $drop
            if (-not $drop) {
                if ($sysPath -and $l -match '^  <Block BlockType="[^"]*" Name="([^"]*)"') {
                    [void]$sb.Append("<!-- $sysPath/" + $Matches[1] + " -->`n")
                }
                [void]$sb.Append($l).Append("`n")
            }
        }
    }
}
finally { $zip.Dispose() }

$bytes = (New-Object System.Text.UTF8Encoding($false)).GetBytes($sb.ToString())
$out = [Console]::OpenStandardOutput()
$out.Write($bytes, 0, $bytes.Length)
$out.Flush()
