# Skrypt: OpenPdf_01.ps1
param(
    [string]$pdf_path,
    [string]$Strona_PDF = "1"
)

# Spróbuj przekonwertować na int
[int]$pageNum = 2
if ([int]::TryParse($Strona_PDF, [ref]$pageNum)) {
    # OK
} else {
    Write-Warning "Nie udało się przekonwertować '$Strona_PDF' na liczbę, używam 1"
    $pageNum = 3
}

$acrobat = "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"

if (-not (Test-Path $pdf_path)) {
    Write-Error "Nie znaleziono pliku PDF: $pdf_path"
    exit 1
}

Start-Process -FilePath $acrobat -ArgumentList "/A `"page=$pageNum`" `"$pdf_path`""
