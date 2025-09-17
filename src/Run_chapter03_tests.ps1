<#
.SYNOPSIS
    Run each pytest file in Chapter03 separately and save output to log files.

.DESCRIPTION
    - Finds all .py files in the specified Chapter03 directory
    - Runs pytest on each file individually
    - Saves the output of each run (stdout + stderr) to a separate .log file
    - Overwrites logs on each run
    - Prints colored progress/status to the console
#>

# Path to the Chapter03 test directory
$testsDir = "C:\GitHub\Repo\Introduction-to-Algorithms-clrs-exercises\tests\Chapter03"

# Path to the log directory (inside current script location)
$logDir = "C:\GitHub\Repo\Scripts\src\2025.09.10_tests_Chapter03"

# Create log directory if it does not exist
if (-not (Test-Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory | Out-Null
}

# Get all Python test files (*.py) in Chapter03 (non-recursive)
$testFiles = Get-ChildItem -Path $testsDir -Filter *.py -File

foreach ($file in $testFiles) {
    $testName = $file.BaseName
    $logFile = Join-Path $logDir "$testName.log"

    Write-Host "=== Running test: $($file.Name) ===" -ForegroundColor Cyan
    Write-Host "Saving output to: $logFile" -ForegroundColor Yellow

    # Run pytest on the file, capture stdout+stderr, overwrite log each time
    # Works in Windows PowerShell 5.1 (no -Encoding parameter)
    pytest $file.FullName -v *>&1 | Tee-Object -FilePath $logFile

    if ($LASTEXITCODE -eq 0) {
        Write-Host "PASS: $($file.Name)" -ForegroundColor Green
    }
    else {
        Write-Host "FAIL: $($file.Name) - see log: $($file.Name).log" -ForegroundColor Red
    }
}

Write-Host "=== All Chapter03 tests completed. Logs saved in: $logDir ===" -ForegroundColor Green
