Install-Module -Name PSScriptAnalyzer -Force

describe 'Module-level tests' {

    it 'the module imports successfully' {
        { Import-Module "$PSScriptRoot\src\M365.Toolbox.psm1" -ErrorAction Stop } | should -not throw
    }

    it 'the module has an associated manifest' {
        Test-Path "$PSScriptRoot\src\M365.Toolbox.psd1" | should -Be $true
    }

    it 'passes all default PSScriptAnalyzer rules' {
        Invoke-ScriptAnalyzer -Path "$PSScriptRoot\src\M365.Toolbox.psm1" | should -BeNullOrEmpty
    }

}