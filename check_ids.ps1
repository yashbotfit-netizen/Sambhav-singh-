$path_graphic = "C:\Users\Sambhav\.gemini\antigravity\brain\3a3dae59-a9f8-4e2a-8674-8b51aaa0865e\.system_generated\steps\160\content.md"
$path_video = "C:\Users\Sambhav\.gemini\antigravity\brain\3a3dae59-a9f8-4e2a-8674-8b51aaa0865e\.system_generated\steps\162\content.md"

$content_g = if (Test-Path $path_graphic) { Get-Content -Raw -Path $path_graphic } else { "" }
$content_v = if (Test-Path $path_video) { Get-Content -Raw -Path $path_video } else { "" }

$ids = @(
    @{ Name = "Rajasthan Travel Diary Showcase"; Id = "1xf-ux9yl3STu7Et89awqpgHtO0LXwosT" },
    @{ Name = "Anti Acne Face Pack Ad"; Id = "1TiFuiMvvfAGfhVTC2P53a_MLSD6HjQpN" },
    @{ Name = "Bright Eyes Skincare Concept"; Id = "1E34OvYGjqahmXkYguCLPCVtiLOHD-4hD" },
    @{ Name = "Instagram Growth Campaign Reel"; Id = "1QS8fHxBxyCMYRhVLLhxN8pkNIgrbqU0D" },
    @{ Name = "Anti Wrinkle Cream Ad"; Id = "1Si7zblSmT8RTmSlhglJ54--IY2BFwZ_Y" },
    @{ Name = "Under Eye Cream Ad"; Id = "17IqrRT4HiTEu4SbXDRN3-tub9NfduG2U" },
    @{ Name = "Ayurveda Skincare Concept"; Id = "1bjP8nir3tJQLIQKSxvHHDqvxn6V3sPaI" },
    @{ Name = "Instagram Skincare Story"; Id = "1AsoMAI3z-PucdtNxBXl1sV4h_stYNYHL" },
    @{ Name = "Winter Essentials Brand Video"; Id = "1QVomhdp2diKjjl4xPqyqfR9Wozbavaio" },
    @{ Name = "Accidentally Vegan Food Video"; Id = "1Rl44jfha9_JGwIw9MA_vdaUMI8OZyTgv" }
)

Write-Host "=== GRAPHIC FOLDER CHECK ===" -ForegroundColor Yellow
foreach ($item in $ids) {
    if ($content_g -match $item.Id) {
        Write-Host "Found in Graphic: $($item.Name) ($($item.Id))" -ForegroundColor Green
    }
}

Write-Host "=== VIDEO FOLDER CHECK ===" -ForegroundColor Yellow
foreach ($item in $ids) {
    if ($content_v -match $item.Id) {
        Write-Host "Found in Video: $($item.Name) ($($item.Id))" -ForegroundColor Green
    }
}
