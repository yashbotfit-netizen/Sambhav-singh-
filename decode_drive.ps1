$path_graphic = "C:\Users\Sambhav\.gemini\antigravity\brain\3a3dae59-a9f8-4e2a-8674-8b51aaa0865e\.system_generated\steps\160\content.md"
$path_video = "C:\Users\Sambhav\.gemini\antigravity\brain\3a3dae59-a9f8-4e2a-8674-8b51aaa0865e\.system_generated\steps\162\content.md"

function Decode-DriveData {
    param($path, $label)
    Write-Host "=== $label ===" -ForegroundColor Yellow
    if (Test-Path $path) {
        $content = [System.IO.File]::ReadAllText($path)
        
        # Search for window['_DRIVE_ivd'] = '...';
        $match = [regex]::Match($content, "window\['_DRIVE_ivd'\] = '(.*?)';")
        if ($match.Success) {
            $hexStr = $match.Groups[1].Value
            
            # Decode hex strings like \x5b to [
            # In powershell we can replace \xXX with [char][int]"0xXX"
            $decoded = [regex]::Replace($hexStr, '\\x([0-9a-fA-F]{2})', {
                param($m)
                [char][int]("0x" + $m.Groups[1].Value)
            })
            
            Write-Host "Decoded Length: $($decoded.Length)"
            # Save decoded data to temp file to view easily or parse it
            # Let's search for filenames in the decoded string
            # Filenames usually look like text ending in .png, .jpg, .mov, etc.
            # Or just text in double quotes
            # Let's write the decoded string to a file first.
            $outPath = "C:\Users\Sambhav\.gemini\antigravity\scratch\decoded_$($label).txt"
            [System.IO.File]::WriteAllText($outPath, $decoded)
            Write-Host "Saved decoded content to: $outPath"
            
            # Let's search for filenames in the decoded string
            $matches_files = [regex]::Matches($decoded, '"([^"]+?\.(?:png|jpg|jpeg|mov|mp4|pdf|zip|gif|webp|svg|psd|ai|prproj))"')
            Write-Host "Found $($matches_files.Count) file matches:"
            $unique_files = @()
            foreach ($f in $matches_files) {
                $unique_files += $f.Groups[1].Value
            }
            $unique_files | Select-Object -Unique | Out-String | Write-Host
            
            # Let's search for pairs of Drive IDs and file names.
            # In the list, it's typically: ["FILE_ID", ["FOLDER_ID"], "FILE_NAME", "MIME_TYPE"]
            # Let's search for patterns of: "([a-zA-Z0-9_-]{33})",\["([a-zA-Z0-9_-]{33})"\]\,"([^"]+?)"
            # Since folder IDs are 33 chars and file IDs are 33 chars, let's look for this
            $pattern_pairs = '"([a-zA-Z0-9_-]{25,35})",\\["[a-zA-Z0-9_-]{25,35}"\\],"([^"]+?)"'
            $matches_pairs = [regex]::Matches($decoded, $pattern_pairs)
            Write-Host "Found $($matches_pairs.Count) parsed item pairs:"
            foreach ($p in $matches_pairs) {
                Write-Host "  ID: $($p.Groups[1].Value) -> Name: $($p.Groups[2].Value)" -ForegroundColor Green
            }
        } else {
            Write-Host "window['_DRIVE_ivd'] not found in $label"
        }
    } else {
        Write-Host "File not found: $path"
    }
}

Decode-DriveData -path $path_graphic -label "GRAPHIC"
Decode-DriveData -path $path_video -label "VIDEO"
