$path = "C:\Users\Sambhav\.gemini\antigravity\brain\3a3dae59-a9f8-4e2a-8674-8b51aaa0865e\.system_generated\steps\160\content.md"
if (Test-Path $path) {
    $content = [System.IO.File]::ReadAllText($path)
    # Search for json strings inside script tags
    # Let's extract script block contents
    $matches = [regex]::Matches($content, '<script[^>]*>(.*?)</script>', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    Write-Host "Found $($matches.Count) script blocks"
    
    # Check if any block contains '1qGU1' or filenames
    foreach ($m in $matches) {
        $script = $m.Groups[1].Value
        if ($script -match "1qGU1" -or $script -match "VIDEO" -or $script -match "GRAPHIC") {
            Write-Host "=== Matching script block (Length: $($script.Length)) ===" -ForegroundColor Yellow
            # Print first 500 and last 500 characters
            if ($script.Length -gt 1000) {
                Write-Host $script.Substring(0, 500)
                Write-Host "... [TRUNCATED] ..."
                Write-Host $script.Substring($script.Length - 500)
            } else {
                Write-Host $script
            }
            Write-Host "========================"
        }
    }
} else {
    Write-Host "File not found"
}
