$data = Get-Content -Raw -Path "C:\Users\Sambhav\.gemini\antigravity\scratch\drive_files_db.json" | ConvertFrom-Json
Write-Host "--- Categories ---"
$data | Group-Object Category | ForEach-Object {
    Write-Host ($_.Name + ": " + $_.Count)
}
Write-Host "--- Subcategories ---"
$data | Group-Object Subcategory | ForEach-Object {
    Write-Host ($_.Name + ": " + $_.Count)
}
