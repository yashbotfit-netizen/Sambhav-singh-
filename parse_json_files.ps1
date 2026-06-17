# Let's write a robust script that reads the preloaded data from the subfolders,
# decodes it, parses it as JSON, and outputs a complete database of Sambhav's files.

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

$dbPath = "C:\Users\Sambhav\.gemini\antigravity\scratch\drive_files_db.json"
$items_db = @()

foreach ($folder in $subfolders) {
    # Let's read the HTML file we downloaded or download fresh
    # Wait, the task-196 log showed we successfully fetched the HTML for each subfolder.
    # Where did task-196 save the HTML? Oh, in task-196, it didn't save the HTML to disk, it just printed.
    # Let's fetch them and extract the JSON directly in this script and parse it!
    $url = "https://drive.google.com/drive/folders/$($folder.Id)"
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
            
            # $decoded contains a string representing a JSON array.
            # Example: [[["FILE_ID", ["PARENT_ID"], "NAME", "MIMETYPE", ...]]]
            # Let's clean it up: it might have escaped slashes
            $json_str = $decoded -replace '\\/', '/'
            
            # Convert to PowerShell JSON object
            # Some values might be unquoted or have special characters, but let's try
            # If standard ConvertFrom-Json fails, we can use a regex parser to extract items.
            try {
                $obj = ConvertFrom-Json $json_str -ErrorAction Stop
                # The root is a nested list.
                # Let's search inside the array
                $list = $obj[0]
                foreach ($item in $list) {
                    $id = $item[0]
                    $name = $item[2]
                    $mime = $item[3]
                    if ($mime -ne "application/vnd.google-apps.folder") {
                        $items_db += @{
                            Category = $folder.Category
                            Subcategory = $folder.Subcategory
                            Id = $id
                            Name = $name
                            Mime = $mime
                        }
                    }
                }
            } catch {
                # Fallback: regex parser to get the fields from the JS array
                # The format is: ["ID",["PARENT_ID"],"NAME","MIME",...
                # Let's extract items using matches of this structure
                $regex = '"([a-zA-Z0-9_-]{25,35})",\\\["[a-zA-Z0-9_-]{25,35}"\\\]\,"([^"]+?)"\,"([^"]+?)"'
                $matches = [regex]::Matches($json_str, $regex)
                foreach ($m in $matches) {
                    $id = $m.Groups[1].Value
                    $name = $m.Groups[2].Value
                    $mime = $m.Groups[3].Value
                    if ($mime -notmatch "folder") {
                        $items_db += @{
                            Category = $folder.Category
                            Subcategory = $folder.Subcategory
                            Id = $id
                            Name = $name
                            Mime = $mime
                        }
                    }
                }
            }
        }
    } catch {
        Write-Host "Error for $($folder.Subcategory): $_"
    }
}

# Export the database to JSON
$items_db | ConvertTo-Json | Out-File -FilePath $dbPath -Encoding utf8
Write-Host "Database saved to: $dbPath"
Write-Host "Total items found: $($items_db.Count)"
