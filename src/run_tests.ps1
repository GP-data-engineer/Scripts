# C:\GitHub\Repo\Scripts\run_tests.ps1
# Runs tests from files test_exercise_4_3_1.py to test_exercise_4_3_9.py

$testDir = "C:\GitHub\Repo\Introduction-to-Algorithms-clrs-exercises\tests\Chapter04"

Write-Host "Starting test execution from directory: $testDir" -ForegroundColor Cyan

for ($i = 1; $i -le 9; $i++) {
    $filename = "test_exercise_4_4_$i.py"
    $filepath = Join-Path $testDir $filename

    if (Test-Path $filepath) {
        Write-Host "▶ Running: $filename" -ForegroundColor Yellow
        pytest $filepath
    } else {
        Write-Host "⚠ File not found: $filename" -ForegroundColor Red
    }
}

Write-Host "✅ Test execution completed." -ForegroundColor Green
