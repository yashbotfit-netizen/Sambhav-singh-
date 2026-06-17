$path_graphic = "C:\Users\Sambhav\.gemini\antigravity\brain\3a3dae59-a9f8-4e2a-8674-8b51aaa0865e\.system_generated\steps\160\content.md"
$path_video = "C:\Users\Sambhav\.gemini\antigravity\brain\3a3dae59-a9f8-4e2a-8674-8b51aaa0865e\.system_generated\steps\162\content.md"

function Get-Files {
    param($path, $label)
    Write-Host "=== $label ===" -ForegroundColor Yellow
    if (Test-Path $path) {
        $content = [System.IO.File]::ReadAllText($path)
        
        # Search for tooltips
        $matches_tooltip = [regex]::Matches($content, 'data-tooltip="([^"]+?)"')
        $items = @()
        foreach ($m in $matches_tooltip) {
            $val = $m.Groups[1].Value
            if ($val -notmatch "Sort" -and $val -notmatch "folder") {
                $items += $val
            }
        }
        
        # Search for aria-labels
        $matches_label = [regex]::Matches($content, 'aria-label="([^"]+?)"')
        foreach ($m in $matches_label) {
            $val = $m.Groups[1].Value
            if ($val -notmatch "Google" -and $val -notmatch "Search" -and $val -notmatch "Sort" -and $val -notmatch "actions" -and $val -notmatch "Download" -and $val -notmatch "folder" -and $val -notmatch "Modified" -and $val -notmatch "Size" -and $val -notmatch "circular") {
                $items += $val
            }
        }
        
        # Search for file extensions anywhere in strings
        $matches_ext = [regex]::Matches($content, '"[^"]+?\.(png|jpg|jpeg|mp4|mov|pdf|zip|gif|webp|svg|psd|ai|prproj)"')
        foreach ($m in $matches_ext) {
            $val = $m.Groups[1].Value
            if ($val -notmatch "ssl.gstatic" -and $val -notmatch "www.gstatic") {
                $items += $val
            }
        }
        
        $items | Select-Object -Unique | Out-String | Write-Host
    } else {
        Write-Host "File not found: $path" -ForegroundColor Red
    }
}

Get-Files -path $path_graphic -label "GRAPHIC SUBFOLDER"
Get-Files -path $path_video -label "VIDEO SUBFOLDER"
