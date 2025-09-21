# Task_Launcher.ps1
# Simple GUI to compose and run: New_Item_ExerciseOrTest.ps1 -Chapter 04 -Name a_b_c
# Author: Grzegorz-ready
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Config
$ScriptName = "New_Item_ExerciseOrTest.ps1"
$WorkingDir = "C:\GitHub\Repo\Scripts"   # zmień na katalog, gdzie leżą skrypty
$Default = @{
    Chapter = 4
    A = 4
    B = 4
    C = 9
}

function Pad2($n){ '{0:D2}' -f [int]$n }
function Build-Command {
    param($Chapter, $A, $B, $C)
    return "$ScriptName -Chapter $(Pad2 $Chapter) -Name $A" + "_" + "$B" + "_" + "$C"
}

# Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Task Launcher"
$form.Size = New-Object System.Drawing.Size(620, 300)
$form.StartPosition = "CenterScreen"

# Labels and NumericUpDowns
$lblChapter = New-Object System.Windows.Forms.Label
$lblChapter.Text = "Chapter"
$lblChapter.Location = '20,20'
$form.Controls.Add($lblChapter)

$numChapter = New-Object System.Windows.Forms.NumericUpDown
$numChapter.Minimum = 0; $numChapter.Maximum = 999
$numChapter.Value = $Default.Chapter
$numChapter.Location = '100,18'
$numChapter.Width = 80
$form.Controls.Add($numChapter)

$lblName = New-Object System.Windows.Forms.Label
$lblName.Text = "Name a_b_c"
$lblName.Location = '20,60'
$form.Controls.Add($lblName)

$numA = New-Object System.Windows.Forms.NumericUpDown
$numA.Minimum = 0; $numA.Maximum = 999
$numA.Value = $Default.A
$numA.Location = '120,58'
$numA.Width = 60
$form.Controls.Add($numA)

$numB = New-Object System.Windows.Forms.NumericUpDown
$numB.Minimum = 0; $numB.Maximum = 999
$numB.Value = $Default.B
$numB.Location = '190,58'
$numB.Width = 60
$form.Controls.Add($numB)

$numC = New-Object System.Windows.Forms.NumericUpDown
$numC.Minimum = 0; $numC.Maximum = 999
$numC.Value = $Default.C
$numC.Location = '260,58'
$numC.Width = 60
$form.Controls.Add($numC)

# Command preview
$lblCmd = New-Object System.Windows.Forms.Label
$lblCmd.Text = "Command:"
$lblCmd.Location = '20,100'
$form.Controls.Add($lblCmd)

$txtCmd = New-Object System.Windows.Forms.TextBox
$txtCmd.Location = '20,120'
$txtCmd.Width = 560
$txtCmd.ReadOnly = $true
$form.Controls.Add($txtCmd)

function Refresh-Cmd {
    $txtCmd.Text = Build-Command -Chapter $numChapter.Value -A $numA.Value -B $numB.Value -C $numC.Value
}
$numChapter.add_ValueChanged({ Refresh-Cmd })
$numA.add_ValueChanged({ Refresh-Cmd })
$numB.add_ValueChanged({ Refresh-Cmd })
$numC.add_ValueChanged({ Refresh-Cmd })
Refresh-Cmd

# Buttons
$btnCopy = New-Object System.Windows.Forms.Button
$btnCopy.Text = "Copy"
$btnCopy.Location = '20,160'
$btnCopy.Add_Click({
    Set-Clipboard -Value $txtCmd.Text
    [System.Windows.Forms.MessageBox]::Show("Copied.")
})
$form.Controls.Add($btnCopy)

$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = "Run"
$btnRun.Location = '100,160'
$btnRun.Add_Click({
    $cmd = $txtCmd.Text
    Push-Location $WorkingDir
    try {
        # uruchomienie skryptu PS z parametrami
        & pwsh -NoLogo -ExecutionPolicy Bypass -File ".\${ScriptName}" @(
            "-Chapter", (Pad2 $numChapter.Value),
            "-Name", "$($numA.Value)_$($numB.Value)_$($numC.Value)"
        )
    } finally {
        Pop-Location
    }
})
$form.Controls.Add($btnRun)

$btnOpenTerm = New-Object System.Windows.Forms.Button
$btnOpenTerm.Text = "Open Terminal Here"
$btnOpenTerm.Location = '180,160'
$btnOpenTerm.Add_Click({
    Start-Process wt.exe -ArgumentList "-d `"$WorkingDir`""
})
$form.Controls.Add($btnOpenTerm)

$btnExit = New-Object System.Windows.Forms.Button
$btnExit.Text = "Exit"
$btnExit.Location = '320,160'
$btnExit.Add_Click({ $form.Close() })
$form.Controls.Add($btnExit)

[void]$form.ShowDialog()
