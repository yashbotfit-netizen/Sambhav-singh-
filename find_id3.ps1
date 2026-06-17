$lines = Get-Content -Path "C:\Users\Sambhav\.gemini\antigravity\scratch\sambhav-creative-portfolio\drive_files_db.json"
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -like "*1sXAfnm1cVaTMm49wHNTDoeQnvhXlvU3i*") {
        Write-Host "Match found on line: $($i + 1)"
        $start = [Math]::Max(0, $i - 5)
        $end = [Math]::Min($lines.Count - 1, $i + 5)
        for ($j = $start; $j -le $end; $j++) {
            Write-Host "$($j + 1): $($lines[$j])"
        }
    }
}
