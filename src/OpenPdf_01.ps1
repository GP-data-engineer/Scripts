param(
    [string]$PdfPath,
    [int]$Page = 1
)

# Ścieżka do Adobe Acrobat
$viewer = "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"

if (-not (Test-Path $PdfPath)) {
    Write-Error "Nie znaleziono pliku PDF: $PdfPath"
    exit 1
}

# Adobe Acrobat obsługuje parametr /A "page=<nr>"
Start-Process -FilePath $viewer -ArgumentList "/A `"page=$Page`" `"$PdfPath`""
