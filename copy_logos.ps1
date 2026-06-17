$dest = "C:\Users\Sambhav\.gemini\antigravity\scratch\sambhav-creative-portfolio\assets\logos"
if (!(Test-Path $dest)) {
    New-Item -ItemType Directory -Path $dest -Force
}
Copy-Item -Path "D:\rework\Untitled design (2)\*" -Destination $dest -Force
Write-Host "Logos copied successfully!"
