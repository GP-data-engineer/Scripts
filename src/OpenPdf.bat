@echo off
REM --- Argumenty: %1 = ścieżka do PDF, %2 = numer strony ---

set "pdf_path=%~1"
set "Strona_PDF=%~2"

REM Ścieżka do Acrobata
set "ACROBAT=C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"

if not exist "%pdf_path%" (
    echo Nie znaleziono pliku PDF: %pdf_path%
    exit /b 1
)

REM Uruchom Acrobat na wskazanej stronie
"%ACROBAT%" /A "page=%Strona_PDF%" "%pdf_path%"
