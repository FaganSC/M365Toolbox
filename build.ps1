$buildVersion = "0.0.0.2"
$moduleName = 'M365.Toolbox'

$manifestPath = Join-Path -Path "$($pwd)\src" -ChildPath "$moduleName.psd1"

## Update build version in manifest
$manifestContent = Get-Content -Path $manifestPath -Raw
$manifestContent = $manifestContent -replace '<ModuleVersion>', $buildVersion

## Find all of the public functions
$publicFuncFolderPath = Join-Path -Path "$($pwd)\src" -ChildPath 'public'
if ((Test-Path -Path $publicFuncFolderPath) -and ($publicFunctionNames = Get-ChildItem -Path $publicFuncFolderPath -Filter '*.ps1' -Recurse | Select-Object -ExpandProperty BaseName)) {
    $funcStrings = "'$($publicFunctionNames -join "','")'"
} else {
    $funcStrings = $null
}
## Add all public functions to FunctionsToExport attribute
$manifestContent = $manifestContent -replace "'<FunctionsToExport>'", $funcStrings
$manifestContent | Set-Content -Path $manifestPath
