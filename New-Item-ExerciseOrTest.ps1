param(
    [int]$Count = 1,
    [int]$Minor = $null,
    [int]$Number = $null,
    [switch]$OnlyTest,
    [switch]$OnlyExercise,
    [switch]$Sync
)

$cwd = Get-Location
$folderName = Split-Path $cwd -Leaf

if ($folderName -notmatch '^Chapter\d+$') {
    Write-Error "Uruchom skrypt z katalogu src/ChapterXX lub tests/ChapterXX"
    exit
}

$chapterNumber = $folderName -replace 'Chapter', ''
$baseDir = Split-Path $cwd -Parent
$repoRoot = Split-Path $baseDir -Parent

if ($baseDir -like "*\src") {
    $mode = "src"
    $srcDir = $cwd
    $testsDir = Join-Path $repoRoot "tests\$folderName"
} elseif ($baseDir -like "*\tests") {
    $mode = "tests"
    $testsDir = $cwd
    $srcDir = Join-Path $repoRoot "src\$folderName"
} else {
    Write-Error "Nie rozpoznano trybu (src/tests)"
    exit
}

function Get-LastTaskNumber($dir, $pattern) {
    $existing = Get-ChildItem -Path $dir -Filter $pattern -ErrorAction SilentlyContinue |
        ForEach-Object {
            if ($_ -match '(\d+)_(\d+)_(\d+)\.py') {
                [PSCustomObject]@{
                    Major = [int]$matches[1]
                    Minor = [int]$matches[2]
                    Task  = [int]$matches[3]
                }
            }
        }
    if ($existing) {
        return ($existing | Sort-Object Major, Minor, Task -Descending | Select-Object -First 1)
    }
    return $null
}

# --- SYNC MODE ---
if ($Sync) {
    Write-Host "=== SYNC REPORT for $folderName ===" -ForegroundColor Cyan

    $srcFiles = Get-ChildItem -Path $srcDir -Filter "*.py" -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '(\d+)_(\d+)_(\d+)\.py' } |
        ForEach-Object { $_.BaseName }

    $testFiles = Get-ChildItem -Path $testsDir -Filter "*.py" -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '(\d+)_(\d+)_(\d+)\.py' } |
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
        Write-Host "`nBrakujące TESTY dla istniejących plików źródłowych:" -ForegroundColor Yellow
        $missingTests | ForEach-Object { Write-Host " - $_" }
    } else {
        Write-Host "`nBraków testów nie znaleziono." -ForegroundColor Green
    }

    if ($missingSrc.Count -gt 0) {
        Write-Host "`nBrakujące PLIKI ŹRÓDŁOWE dla istniejących testów:" -ForegroundColor Yellow
        $missingSrc | ForEach-Object { Write-Host " - $_" }
    } else {
        Write-Host "`nBraków plików źródłowych nie znaleziono." -ForegroundColor Green
    }

    exit
}

# --- NORMAL MODE (tworzenie plików) ---
$last = if ($mode -eq "src") {
    Get-LastTaskNumber $srcDir "Exercise_*.py"
} else {
    Get-LastTaskNumber $testsDir "test_exercise_*.py"
}

if ($Number -and $Minor) {
    $nextMinor = $Minor
    $nextTask = $Number
} elseif ($last) {
    $nextMinor = if ($Minor) { $Minor } else { $last.Minor }
    $nextTask = if ($Number) { $Number } else { $last.Task + 1 }
} else {
    $nextMinor = if ($Minor) { $Minor } else { 1 }
    $nextTask = if ($Number) { $Number } else { 1 }
}

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
    print("Demonstration of Exercise ${chapterNumber}.${nextMinor}.${nextTask}:")
    example_result = solution_function()
    print("Example result:", example_result)
"@

$testTemplate = @"
\"\"\"
proof or explanation (comment in English):
\"\"\"

import pytest
from src.Chapter${chapterNumber}.Exercise_${chapterNumber}_${nextMinor}_${nextTask} import solution_function

def test_basic_case():
    assert solution_function() is None

def test_additional_case():
    assert True
"@

for ($i = 0; $i -lt $Count; $i++) {
    $taskNum = $nextTask + $i
    $exerciseFile = "Exercise_${chapterNumber}_${nextMinor}_${taskNum}.py"
    $testFile = "test_exercise_${chapterNumber}_${nextMinor}_${taskNum}.py"

    if ($mode -eq "src" -or $OnlyExercise) {
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
            if (-not (Test-Path $testsDir)) { New-Item -ItemType Directory -Path $testsDir | Out-Null }
            $testPath = Join-Path $testsDir $testFile
            if (-not (Test-Path $testPath)) {
                Set-Content -Path $testPath -Value $testTemplate -Encoding UTF8
                Write-Host "Created test file:" $testFile
            } else {
                Write-Warning "Test file already exists: $testFile"
            }
        }
    }

    if ($mode -eq "tests") {
        if (-not $OnlyTest) {
            $exercisePath = Join-Path $srcDir $exerciseFile
            if (-not (Test-Path $exercisePath)) {
                Write-Warning "Brak pliku źródłowego: $exerciseFile w $srcDir"
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
    }
}
