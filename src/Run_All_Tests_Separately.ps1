<#
.SYNOPSIS
    Run each pytest file in tests\Chapter03 separately and save output to log files.

.DESCRIPTION
    - Finds all .py files in the specified tests\Chapter03 directory
    - Runs pytest on each file individually
    - Saves the output of each run to a separate .log file
    - Prints progress to the console
#>

# Ścieżka do katalogu z testami
$testsDir = "C:\Data_Engineer\Kopia_Repo_2025.09.08\Repo\Introduction-to-Algorithms-clrs-exercises\tests\Chapter03"

# Pobierz wszystkie pliki .py w katalogu (bez rekurencji)
$testFiles = Get-ChildItem -Path $testsDir -Filter *.py -File

# Utwórz katalog na logi (w tym samym miejscu, gdzie uruchamiasz skrypt)
$logDir = Join-Path -Path (Get-Location) -ChildPath "test_logs"
if (-not (Test-Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory | Out-Null
}

foreach ($file in $testFiles) {
    $testName = $file.BaseName
    $logFile = Join-Path $logDir "$testName.log"

    Write-Host "=== Running test: $($file.Name) ===" -ForegroundColor Cyan
    Write-Host "Saving output to: $logFile" -ForegroundColor Yellow

    # Uruchom pytest na danym pliku i zapisz wynik do loga
    pytest $file.FullName -v *>&1 | Tee-Object -FilePath $logFile
}

Write-Host "=== All tests completed. Logs saved in: $logDir ===" -ForegroundColor Green
