[CmdletBinding()]
param(
    [Alias('FullName','Path')]
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string] $AsmFilePath
)

$asmFile = Get-ChildItem $AsmFilePath
$AsmFilePath = $asmFile.FullName

$asmaDir = $PSScriptRoot
$fasmDir = "$PSScriptRoot\..\fasm"

$oldInclude = $env:INCLUDE
$env:INCLUDE = "$fasmDir\INCLUDE;$asmaDir\include"

& $fasmDir\fasm.exe $AsmFilePath

if ($oldInclude) { $env:INCLUDE = $oldInclude}