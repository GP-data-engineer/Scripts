param(
    [Parameter(Mandatory=$true)]
    [string]$NotePath
)

# Upewnij się, że plik notatki istnieje
if (-not (Test-Path $NotePath)) {
    Write-Error "Note file not found: $NotePath"
    exit 1
}

# Wczytaj YAML z notatki (pierwsze 20 linii)
$yaml = Get-Content $NotePath -TotalCount 20

function Get-YamlValue($key) {
    $pattern = "^$([regex]::Escape($key)):"
    $line = $yaml | Where-Object { $_ -match $pattern }
    if ($line) { return ($line -split ':')[1].Trim() }
    return $null
}


$chapter = Get-YamlValue "chapter"
$name_a  = Get-YamlValue "name_a"
$name_b  = Get-YamlValue "name_b"
$name_c  = Get-YamlValue "name_c"

if (-not $chapter -or -not $name_a -or -not $name_b -or -not $name_c) {
    Write-Error "Missing YAML values in note."
    exit 1
}

$chapterPadded = "{0:D2}" -f [int]$chapter
$name = "${name_a}_${name_b}_${name_c}"

# Ścieżka do głównego skryptu
$scriptPath = "C:\GitHub\Repo\Scripts\src\New_Item_ExerciseOrTest.ps1"

if (-not (Test-Path $scriptPath)) {
    Write-Error "Script not found: $scriptPath"
    exit 1
}

Write-Host "Running: $scriptPath -Chapter $chapterPadded -Name $name"
& $scriptPath -Chapter $chapterPadded -Name $name
