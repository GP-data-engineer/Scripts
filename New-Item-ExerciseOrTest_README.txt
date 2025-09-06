========================================
New-Item-ExerciseOrTest.ps1 - Quick Guide
========================================

ENGLISH
-------

DESCRIPTION:
This PowerShell script creates template files for exercises and their tests
in the "Introduction-to-Algorithms-clrs-exercises" repository.
It is always run from:
  C:\GitHub\Repo\Scripts

It creates files in:
  src\ChapterXX
  tests\ChapterXX
where XX is the chapter number (01..35).

OPTIONS:
-Chapter XX     → chapter number (required, e.g., 01, 02, ..., 35)
-Name X_Y_Z     → task name (required unless -Sync), e.g., 1_2_3
-OnlyExercise   → create only the exercise file
-OnlyTest       → create only the test file
-Sync           → list missing tests for existing exercises and missing exercises for existing tests

USAGE EXAMPLES:

1. Create exercise + test in Chapter03 for task 1_2_3:
   PS> .\New-Item-ExerciseOrTest.ps1 -Chapter 03 -Name 1_2_3

2. Create only exercise file:
   PS> .\New-Item-ExerciseOrTest.ps1 -Chapter 03 -Name 1_2_3 -OnlyExercise

3. Create only test file:
   PS> .\New-Item-ExerciseOrTest.ps1 -Chapter 03 -Name 1_2_3 -OnlyTest

4. Check missing tests/exercises in Chapter03:
   PS> .\New-Item-ExerciseOrTest.ps1 -Chapter 03 -Sync


POLSKI
------

OPIS:
Ten skrypt PowerShell tworzy pliki szablonów dla zadań i ich testów
w repozytorium "Introduction-to-Algorithms-clrs-exercises".
Zawsze uruchamiany z:
  C:\GitHub\Repo\Scripts

Tworzy pliki w:
  src\ChapterXX
  tests\ChapterXX
gdzie XX to numer rozdziału (01..35).

OPCJE:
-Chapter XX     → numer rozdziału (wymagany, np. 01, 02, ..., 35)
-Name X_Y_Z     → nazwa zadania (wymagana, chyba że -Sync), np. 1_2_3
-OnlyExercise   → utwórz tylko plik zadania
-OnlyTest       → utwórz tylko plik testu
-Sync           → pokaż brakujące testy dla istniejących zadań i brakujące zadania dla istniejących testów

PRZYKŁADY:

1. Utwórz zadanie + test w Chapter03 dla zadania 1_2_3:
   PS> .\New-Item-ExerciseOrTest.ps1 -Chapter 03 -Name 1_2_3

2. Utwórz tylko plik zadania:
   PS> .\New-Item-ExerciseOrTest.ps1 -Chapter 03 -Name 1_2_3 -OnlyExercise

3. Utwórz tylko plik testu:
   PS> .\New-Item-ExerciseOrTest.ps1 -Chapter 03 -Name 1_2_3 -OnlyTest