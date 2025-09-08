"""
Pytest test for the PowerShell script New_Item_ExerciseOrTest.ps1.

This test runs the script in different modes and verifies that:
1. It creates the expected source and test files in the correct directories.
2. The created files contain the expected template content.
"""

import subprocess
import shutil
import tempfile
from pathlib import Path
import pytest

# Path to the PowerShell script
SCRIPT_PATH = Path(r"C:\GitHub\Repo\Introduction-to-Algorithms-clrs-exercises\New_Item_ExerciseOrTest.ps1")

@pytest.fixture
def temp_repo(tmp_path):
    """
    Fixture to create a temporary fake repo structure for testing.
    """
    repo_root = tmp_path / "Introduction-to-Algorithms-clrs-exercises"
    (repo_root / "src").mkdir(parents=True)
    (repo_root / "tests").mkdir(parents=True)
    return repo_root

def run_ps_script(args, cwd):
    """
    Helper to run the PowerShell script with given arguments.
    """
    cmd = ["pwsh", "-File", str(SCRIPT_PATH)] + args
    result = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
    return result

def test_creates_exercise_and_test_files(temp_repo):
    """
    Test that the script creates both the exercise and test files.
    """
    chapter = "01"
    name = "3_1_6"
    src_dir = temp_repo / f"src/Chapter{chapter}"
    tests_dir = temp_repo / f"tests/Chapter{chapter}"

    # Run the script
    result = run_ps_script(
        ["-Chapter", chapter, "-Name", name],
        cwd=temp_repo
    )

    # Ensure script executed successfully
    assert result.returncode == 0, f"Script failed: {result.stderr}"

    # Check that files exist
    exercise_file = src_dir / f"Exercise_{name}.py"
    test_file = tests_dir / f"test_exercise_{name}.py"

    assert exercise_file.exists(), "Exercise file was not created"
    assert test_file.exists(), "Test file was not created"

    # Check that template content is present
    exercise_content = exercise_file.read_text(encoding="utf-8")
    test_content = test_file.read_text(encoding="utf-8")

    assert "def solution_function" in exercise_content
    assert "import pytest" in test_content

def test_only_creates_test_file(temp_repo):
    """
    Test that the script creates only the test file when -OnlyTest is used.
    """
    chapter = "02"
    name = "3_1"
    tests_dir = temp_repo / f"tests/Chapter{chapter}"

    result = run_ps_script(
        ["-Chapter", chapter, "-Name", name, "-OnlyTest"],
        cwd=temp_repo
    )

    assert result.returncode == 0, f"Script failed: {result.stderr}"
    assert (tests_dir / f"test_problem_{name}.py").exists()
    # No src file should be created
    assert not (temp_repo / f"src/Chapter{chapter}/Problem_{name}.py").exists()
