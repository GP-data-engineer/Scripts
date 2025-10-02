# Skrypt: OpenPdf.ps1
param(
    [string]$PdfPath,
    [string]$Page = "1"
)

# Spróbuj przekonwertować na int, jeśli się nie uda, ustaw 1
[int]$pageNum = 1
if (-not [int]::TryParse($Page, [ref]$pageNum)) {
    Write-Warning "Nie udało się przekonwertować '$Page' na liczbę – używam 1"
    $pageNum = 1
}

$acrobat = "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"

if (-not (Test-Path $PdfPath)) {
    Write-Error "Nie znaleziono pliku PDF: $PdfPath"
    exit 1
}

Start-Process -FilePath $acrobat -ArgumentList "/A `"page=$pageNum`" `"$PdfPath`""

