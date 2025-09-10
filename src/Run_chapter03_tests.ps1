# Define the path to the test directory
$TestDirectory = "C:\GitHub\Repo\Introduction-to-Algorithms-clrs-exercises\tests\Chapter03"

# Define the output log directory
$LogDirectory = "C:\GitHub\Repo\Scripts\src\2025.09.10_tests_Chapter03"

# Create the log directory if it does not exist
# This ensures that logs are always stored in the correct location
if (-not (Test-Path -Path $LogDirectory)) {
    New-Item -ItemType Directory -Path $LogDirectory | Out-Null
}

# Get all test files from the Chapter03 directory
# Assuming tests are executable scripts or files that can be run directly
$TestFiles = Get-ChildItem -Path $TestDirectory -File

# Loop through each test file and execute it
foreach ($TestFile in $TestFiles) {
    # Create a log file name based on the test file name
    $LogFileName = [System.IO.Path]::GetFileNameWithoutExtension($TestFile.Name) + ".log"
    $LogFilePath = Join-Path $LogDirectory $LogFileName

    # Write a message to the console for tracking progress
    Write-Host "Running test: $($TestFile.Name) -> Log: $LogFileName" -ForegroundColor Yellow

    # Run the test and redirect all output (stdout and stderr) to the log file
    # The output redirection with '>' overwrites the file each time
    & $TestFile.FullName *> $LogFilePath
}

Write-Host "All Chapter03 tests have been executed. Logs are in: $LogDirectory" -ForegroundColor Green
