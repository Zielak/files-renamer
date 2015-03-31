# Haxe files-renamer

Batch rename your files from a folder to new names from a text file.

# Usage

From your terminal

```
./Main /Users/name/Desktop/files2rename /Users/name/Desktop/newFilenames.txt
```

## Arguments

1. `folder` - where are your files located
2. `newfilenames.txt` - text file of new filenames
3. `-pretend` - optional, see what script would do without changing names

old files should have numbers to be matched with each line from a text file. Old filenames are stripped to digits only and sorted by it before renaming