import re
import json

path = r"C:\Users\Sambhav\.gemini\antigravity\brain\3a3dae59-a9f8-4e2a-8674-8b51aaa0865e\.system_generated\steps\130\content.md"

with open(path, "r", encoding="utf-8") as f:
    html = f.read()

# Let's search for json-like structures that contain file metadata.
# Typically Google Drive folder pages store item data in variables or script blocks.
# Let's search for the files in the HTML.
# Look for text inside quotes that looks like filenames or Google Drive IDs.
# Or look for patterns like: [ "id", "name", ... ]
# Let's print out snippets that match some common graphic/video extensions.
matches = re.findall(r'[^"\r\n\t]+?\.(?:png|jpg|jpeg|mp4|mov|pdf|zip|gif|webp|svg|psd|ai|prproj)', html, re.IGNORECASE)
print("--- Found extensions matches ---")
for m in set(matches):
    # print match and some surrounding context if short
    if len(m) < 100:
        print(m.strip())

# Let's also look for Drive item details. Sometimes they are embedded in script elements like:
# init('id', 'name', 'mimeType', ...)
# Let's extract Google Drive file links/IDs
print("\n--- Found Drive links/IDs ---")
ids = re.findall(r'https://drive\.google\.com/file/d/([a-zA-Z0-9_-]{20,})', html)
for i in set(ids):
    print(i)
