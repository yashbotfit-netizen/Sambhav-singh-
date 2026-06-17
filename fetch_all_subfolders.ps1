$subfolders = @(
    # Graphic subfolders
    @{ Category = "GRAPHIC"; Subcategory = "a++"; Id = "1sNnhC4OUq14QNM03aJSs_nrLx2tny45z" },
    @{ Category = "GRAPHIC"; Subcategory = "AI"; Id = "1oljlnKxU9ULfU0p4jgO3AuF0eCa5dS8F" },
    @{ Category = "GRAPHIC"; Subcategory = "BANNER"; Id = "1-SuS4PqUM0gzzU_vlgdM3ij4K2-tET2E" },
    @{ Category = "GRAPHIC"; Subcategory = "CREATIVES"; Id = "1LlJGBY8JdtpFpcx1XBq9A35pNf0761py" },
    # Video subfolders
    @{ Category = "VIDEO"; Subcategory = "AI VIDEO"; Id = "1sFeRc0hoeQ4WFDj39aA4ATRABreCH54y" },
    @{ Category = "VIDEO"; Subcategory = "amazon reel"; Id = "1oxDF1RgkTyMbgDLDxX1gDRX0DtmqZ06I" },
    @{ Category = "VIDEO"; Subcategory = "EDIT+SHOOT VIDEO"; Id = "11qgEG9GehnbzQv0-YHqOkyj11RJ4D9Tu" },
    @{ Category = "VIDEO"; Subcategory = "LONG FORM VIDEO"; Id = "1gsuE-UE6gFWMYESM2rjkVIbvAibtYphv" },
    @{ Category = "VIDEO"; Subcategory = "Video"; Id = "1QH81aDebS2PYIMS69paPlNlk0s95zj5D" }
)

$outPath = "C:\Users\Sambhav\.gemini\antigravity\scratch\drive_files_list.txt"
"=== GOOGLE DRIVE FOLDER CONTENT ===" | Out-File -FilePath $outPath -Encoding utf8

foreach ($folder in $subfolders) {
    $url = "https://drive.google.com/drive/folders/$($folder.Id)"
    Write-Host "Fetching: $($folder.Category) -> $($folder.Subcategory) ($url)" -ForegroundColor Yellow
    
    try {
        $resp = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 15
        $html = $resp.Content
        
        $match = [regex]::Match($html, "window\['_DRIVE_ivd'\] = '(.*?)';")
        if ($match.Success) {
            $hexStr = $match.Groups[1].Value
            $decoded = [regex]::Replace($hexStr, '\\x([0-9a-fA-F]{2})', {
                param($m)
                [char][int]("0x" + $m.Groups[1].Value)
            })
            
            # Write heading to log file
            "`n=== $($folder.Category) / $($folder.Subcategory) (ID: $($folder.Id)) ===" | Out-File -FilePath $outPath -Append -Encoding utf8
            
            # Let's search for filenames in the decoded string
            # In decoded string, the structure has: ["FILE_ID", ["PARENT_ID"], "FILE_NAME", "MIME_TYPE"]
            # Let's extract items:
            # We can find all IDs and names by looking for a pattern:
            # "([a-zA-Z0-9_-]{25,35})",\["([a-zA-Z0-9_-]{25,35})"\],"([^"]+?)"
            $pattern = '"([a-zA-Z0-9_-]{25,35})",\\\["[a-zA-Z0-9_-]{25,35}"\\\]\,"([^"]+?)"'
            $matches_pairs = [regex]::Matches($decoded, $pattern)
            
            if ($matches_pairs.Count -eq 0) {
                # Fallback: find any file-like names
                $pattern_fallback = '"([^"]+?\.(?:png|jpg|jpeg|mp4|mov|pdf|zip|gif|webp|svg|psd|ai|prproj))"'
                $matches_fallback = [regex]::Matches($decoded, $pattern_fallback)
                $unique_files = @()
                foreach ($f in $matches_fallback) { $unique_files += $f.Groups[1].Value }
                $unique_files = $unique_files | Select-Object -Unique
                
                foreach ($f in $unique_files) {
                    "  File: $f" | Out-File -FilePath $outPath -Append -Encoding utf8
                    Write-Host "  File: $f" -ForegroundColor Green
                }
            } else {
                $unique_pairs = @()
                foreach ($p in $matches_pairs) {
                    $unique_pairs += [PSCustomObject]@{
                        Id = $p.Groups[1].Value
                        Name = $p.Groups[2].Value
                    }
                }
                $unique_pairs = $unique_pairs | Group-Object Id | ForEach-Object { $_.Group[0] }
                
                foreach ($item in $unique_pairs) {
                    "  File: $($item.Name) (ID: $($item.Id))" | Out-File -FilePath $outPath -Append -Encoding utf8
                    Write-Host "  File: $($item.Name) (ID: $($item.Id))" -ForegroundColor Green
                }
            }
        } else {
            Write-Host "  No _DRIVE_ivd found." -ForegroundColor Red
        }
    } catch {
        Write-Host "  Error fetching or parsing: $_" -ForegroundColor Red
    }
}

Write-Host "`nAll subfolders fetched! Log saved to $outPath" -ForegroundColor Cyan
