param(
    [Parameter(Mandatory=$true)]
    [ValidatePattern('^\d{2}$')]
    [string]$Chapter,             # e.g. 01, 02, ..., 35

    [string]$Name,                 # e.g. 1_2_3
    [switch]$OnlyExercise,
    [switch]$OnlyTest,
    [switch]$Sync
)

# Ścieżki bazowe
$repoRoot = "C:\GitHub\Repo\Introduction-to-Algorithms-clrs-exercises"
$srcDir   = Join-Path $repoRoot "src\Chapter$Chapter"
$testsDir = Join-Path $repoRoot "tests\Chapter$Chapter"

# Utwórz katalogi jeśli nie istnieją
if (-not (Test-Path $srcDir))   { New-Item -ItemType Directory -Path $srcDir   | Out-Null }
if (-not (Test-Path $testsDir)) { New-Item -ItemType Directory -Path $testsDir | Out-Null }

# --- SYNC MODE ---
if ($Sync) {
    Write-Host "=== SYNC REPORT for Chapter$Chapter ===" -ForegroundColor Cyan

    $srcFiles = Get-ChildItem -Path $srcDir -Filter "*.py" -ErrorAction SilentlyContinue |
        ForEach-Object { $_.BaseName }

    $testFiles = Get-ChildItem -Path $testsDir -Filter "*.py" -ErrorAction SilentlyContinue |
        ForEach-Object { $_.BaseName }

    $missingTests = @()
    foreach ($src in $srcFiles) {
        $expectedTest = "test_" + $src
        if ($testFiles -notcontains $expectedTest) {
            $missingTests += $expectedTest
        }
    }

    $missingSrc = @()
    foreach ($test in $testFiles) {
        $expectedSrc = $test -replace '^test_', ''
        if ($srcFiles -notcontains $expectedSrc) {
            $missingSrc += $expectedSrc
        }
    }

    if ($missingTests.Count -gt 0) {
        Write-Host "`nMissing TESTS for existing exercises:" -ForegroundColor Yellow
        $missingTests | ForEach-Object { Write-Host " - $_" }
    } else {
        Write-Host "`nNo missing tests found." -ForegroundColor Green
    }

    if ($missingSrc.Count -gt 0) {
        Write-Host "`nMissing EXERCISES for existing tests:" -ForegroundColor Yellow
        $missingSrc | ForEach-Object { Write-Host " - $_" }
    } else {
        Write-Host "`nNo missing exercises found." -ForegroundColor Green
    }

    exit
}

if (-not $Name) {
    Write-Error "You must provide -Name in format X_Y_Z (e.g., 1_2_3)"
    exit
}

$exerciseFile = "Exercise_${Name}.py"
$testFile     = "test_exercise_${Name}.py"

# Szablony
$exerciseTemplate = @"
\"\"\"
Mathematical proof or explanation (comment in English):

[Insert a proof or a description of the solution here, if applicable.]
\"\"\"

def solution_function(*args, **kwargs):
    \"\"\"
    Core solution logic for the exercise.
    Replace parameters and logic with the actual implementation.
    \"\"\"
    # TODO: Implement the actual algorithm
    return None

if __name__ == "__main__":
    print("Demonstration of Exercise ${Name}:")
    example_result = solution_function()
    print("Example result:", example_result)
"@

$testTemplate = @"
\"\"\"
proof or explanation (comment in English):
\"\"\"

import pytest
from src.Chapter$Chapter.Exercise_${Name} import solution_function

def test_basic_case():
    assert solution_function() is None

def test_additional_case():
    assert True
"@

# Tworzenie plików
if (-not $OnlyTest) {
    $exercisePath = Join-Path $srcDir $exerciseFile
    if (-not (Test-Path $exercisePath)) {
        Set-Content -Path $exercisePath -Value $exerciseTemplate -Encoding UTF8
        Write-Host "Created exercise file:" $exerciseFile
    } else {
        Write-Warning "Exercise file already exists: $exerciseFile"
    }
}

if (-not $OnlyExercise) {
    $testPath = Join-Path $testsDir $testFile
    if (-not (Test-Path $testPath)) {
        Set-Content -Path $testPath -Value $testTemplate -Encoding UTF8
        Write-Host "Created test file:" $testFile
    } else {
        Write-Warning "Test file already exists: $testFile"
    }
}
