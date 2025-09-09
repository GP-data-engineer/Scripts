<#
.SYNOPSIS
    Scan .py files in a target directory and ensure that any 'from' import
    statement for Exercise modules contains 'src.Chapter03.' before 'Exercise...'.

.DESCRIPTION
    - Looks only at lines starting with 'from '
    - If 'src.Chapter03.' is missing before 'Exercise', it inserts it
    - Keeps the rest of the line intact
    - Respects the space after 'from ' and does not add a space after 'src.Chapter03.'
    - Prints all changes to console
    - Saves changes to changes_XX.md in the script's directory, incrementing XX if needed
#>

# Define the target directory to scan
$targetDir = "C:\GitHub\Repo\Introduction-to-Algorithms-clrs-exercises\tests\Chapter03"

# Determine the directory where this script is located
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Find the next available changes_X.md filename
$counter = 1
do {
    $changesFile = Join-Path $scriptDir ("changes_{0:D2}.md" -f $counter)
    $counter++
} while (Test-Path $changesFile)

# Prepare a list to store change logs
$changeLog = @()

# Get all .py files in the target directory (non-recursive)
$pyFiles = Get-ChildItem -Path $targetDir -Filter *.py -File

foreach ($file in $pyFiles) {
    $lines = Get-Content -Path $file.FullName
    $modified = $false

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]

        # Check if line starts with 'from '
        if ($line.TrimStart().StartsWith("from ")) {
            # If it contains 'Exercise' but not 'src.Chapter03.'
            if ($line -match "from\s+Exercise" -and $line -notmatch "src\.Chapter03\." ) {
                $oldLine = $line
                # Insert 'src.Chapter03.' after 'from ' but before 'Exercise'
                $lines[$i] = $line -replace "(?<=from\s+)", "src.Chapter03."
                $modified = $true

                # Print change to console
                Write-Host "File: $($file.Name) | Changed: '$oldLine' -> '$($lines[$i])'" -ForegroundColor Yellow

                # Add change to log
                $changeLog += "File: $($file.Name) | Changed: '$oldLine' -> '$($lines[$i])'"
            }
        }
    }

    if ($modified) {
        Set-Content -Path $file.FullName -Value $lines
    }
}

# Save change log to file if there were changes
if ($changeLog.Count -gt 0) {
    $changeLog | Out-File -FilePath $changesFile -Encoding UTF8
    Write-Host "Changes saved to: $changesFile" -ForegroundColor Green
} else {
    Write-Host "No changes were made." -ForegroundColor Cyan
}
