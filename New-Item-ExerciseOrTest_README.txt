========================================
New-Item-ExerciseOrTest.ps1 - Quick Guide
========================================

ENGLISH
-------

DESCRIPTION:
This PowerShell script creates template files for exercises and their tests
in the "Introduction-to-Algorithms-clrs-exercises" repository.
It can be run from either:
 - src/ChapterXX  → creates exercise file and matching test file
 - tests/ChapterXX → creates test file (and optionally checks for matching exercise)

OPTIONS:
-Count N         → create N consecutive files
-Minor X         → set subchapter number (e.g., 3_2_X)
-Number Y        → set specific task number
-OnlyExercise    → create only the exercise file
-OnlyTest        → create only the test file
-Sync            → list missing tests for existing exercises and missing exercises for existing tests

USAGE EXAMPLES:

1. Create next exercise + test automatically (from src/Chapter03):
   PS> .\New-Item-ExerciseOrTest.ps1

2. Create 3 new exercises + tests:
   PS> .\New-Item-ExerciseOrTest.ps1 -Count 3

3. Create only an exercise file:
   PS> .\New-Item-ExerciseOrTest.ps1 -OnlyExercise

4. Create only a test file:
   PS> .\New-Item-ExerciseOrTest.ps1 -OnlyTest

5. Create specific exercise/test (Chapter 3, subchapter 1, task 7):
   PS> .\New-Item-ExerciseOrTest.ps1 -Minor 1 -Number 7

6. Check missing tests/exercises without creating files:
   PS> .\New-Item-ExerciseOrTest.ps1 -Sync


POLSKI
------

OPIS:
Ten skrypt PowerShell tworzy pliki szablonów dla zadań i ich testów
w repozytorium "Introduction-to-Algorithms-clrs-exercises".
Może być uruchamiany z:
 - src/ChapterXX  → tworzy plik zadania i odpowiadający mu plik testu
 - tests/ChapterXX → tworzy plik testu (opcjonalnie sprawdza istnienie pliku źródłowego)

OPCJE:
-Count N         → utwórz N kolejnych plików
-Minor X         → ustaw numer podrozdziału (np. 3_2_X)
-Number Y        → ustaw konkretny numer zadania
-OnlyExercise    → utwórz tylko plik zadania
-OnlyTest        → utwórz tylko plik testu
-Sync            → pokaż brakujące testy dla istniejących zadań i brakujące zadania dla istniejących testów

PRZYKŁADY:

1. Utwórz kolejne zadanie + test automatycznie (z src/Chapter03):
   PS> .\New-Item-ExerciseOrTest.ps1

2. Utwórz 3 kolejne zadania + testy:
   PS> .\New-Item-ExerciseOrTest.ps1 -Count 3

3. Utwórz tylko plik zadania:
   PS> .\New-Item-ExerciseOrTest.ps1 -OnlyExercise

4. Utwórz tylko plik testu:
   PS> .\New-Item-ExerciseOrTest.ps1 -OnlyTest

5. Utwórz konkretne zadanie/test (Rozdział 3, podrozdział 1, zadanie 7):
   PS> .\New-Item-ExerciseOrTest.ps1 -Minor 1 -Number 7

6. Sprawdź brakujące testy/zadania bez tworzenia plików:
   PS> .\New-Item-ExerciseOrTest.ps1 -Sync
