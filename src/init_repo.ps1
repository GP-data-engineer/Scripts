# Nazwa folderu projektu
$PROJECT = "merge_sort_no_sentinels"

# Tworzenie folderu projektu (jeżeli nie istnieje)
mkdir $PROJECT -Force | Out-Null

# Tworzenie folderów src i tests
mkdir "$PROJECT\src" -Force | Out-Null
mkdir "$PROJECT\tests" -Force | Out-Null

# Tworzenie README.md
@"
# Merge Sort without Sentinels (CLRS Exercise 2.3-7*)

This project implements the Merge Sort algorithm without using sentinels
(as in Introduction to Algorithms, CLRS – exercise 2.3-7*).

Run the program:
python src/merge_sort.py

Run tests:
pytest -q
"@ | Set-Content "$PROJECT\README.md" -Encoding UTF8
