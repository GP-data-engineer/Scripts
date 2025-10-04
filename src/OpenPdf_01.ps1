param(
    [string]$Pdf_Path,
    [int]$Page = 1
)

$acrobat = "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"

if (-not (Test-Path $Pdf_Path)) {
    Write-Error "Nie znaleziono pliku PDF: $Pdf_Path"
    exit 1
}

$arg = '/A "page={0}" "{1}"' -f $Page, $Pdf_Path
Start-Process -FilePath $acrobat -ArgumentList $arg