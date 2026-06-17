$data = Get-Content -Raw -Path "C:\Users\Sambhav\.gemini\antigravity\scratch\drive_files_db.json" | ConvertFrom-Json
$videos = $data | Where-Object { $_.Category -eq "VIDEO" }
$groups = $videos | Group-Object Subcategory
foreach ($g in $groups) {
    Write-Host "=== Subcategory: $($g.Name) ==="
    $g.Group | Select-Object -First 5 | ForEach-Object {
        Write-Host "  - $($_.Name) (ID: $($_.Id))"
    }
}
