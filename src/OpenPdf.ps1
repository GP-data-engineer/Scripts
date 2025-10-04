
param(
    [string]$PdfPath,
    [string]$Page = "1"
)

# Konwersja numeru strony (bez sztywnych wartości „15”)
[int]$pageNum = 1
if (-not [int]::TryParse($Page, [ref]$pageNum)) {
    Write-Warning "Nie udało się przekonwertować '$Page' na liczbę – używam 1"
    $pageNum = 1
}

# Ścieżka do Acrobata
$acrobat = "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"

# Walidacja pliku PDF
if (-not (Test-Path $PdfPath)) {
    Write-Error "Nie znaleziono pliku PDF: $PdfPath"
    exit 1
}

# Zbuduj argumenty stabilnie, bez backticków
$arg = '/A "page={0}" "{1}"' -f $pageNum, $PdfPath
Write-Host "Uruchamiam: $acrobat $arg"  # pomocne w debugowaniu

Start-Process -FilePath $acrobat -ArgumentList $arg
