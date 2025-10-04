param(
    [string]$PdfPath,
    [string]$Page = "1"
)

# --- Konwersja numeru strony ---
[int]$pageNum = 1
if (-not [int]::TryParse($Page, [ref]$pageNum)) {
    Write-Warning "Nie udało się przekonwertować '$Page' na liczbę – używam 1"
    $pageNum = 1
}

# --- Ścieżka do Acrobata ---
$acrobat = "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"

# --- Walidacja pliku PDF ---
if (-not (Test-Path $PdfPath)) {
    Write-Error "Nie znaleziono pliku PDF: $PdfPath"
    exit 1
}

# --- Budowanie argumentów jako TABLICA ---
# To jest kluczowe: Acrobat musi dostać /A, page=XX i ścieżkę jako osobne elementy
$arg = @("/A", "page=$pageNum", $PdfPath)

Write-Host "DEBUG: Uruchamiam: $acrobat $($arg -join ' ')"

# --- Start procesu ---
Start-Process -FilePath $acrobat -ArgumentList $arg
