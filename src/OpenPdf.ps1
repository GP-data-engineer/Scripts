# Skrypt: OpenPdf.ps1
param(
    [string]$PdfPath,
    [string]$Page = "76"
)

# Spróbuj przekonwertować na int
[int]$pageNum = 76
if ([int]::TryParse($Page, [ref]$pageNum)) {
    # OK
} else {
    Write-Warning "Nie udało się przekonwertować '$Page' na liczbę, używam 1"
    $pageNum = 1
}

$acrobat = "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"

if (-not (Test-Path $PdfPath)) {
    Write-Error "Nie znaleziono pliku PDF: $PdfPath"
    exit 1
}

Start-Process -FilePath $acrobat -ArgumentList "/A `"page=$pageNum`" `"$PdfPath`""
