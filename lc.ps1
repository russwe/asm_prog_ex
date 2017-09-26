[CmdletBinding()]
param(
    [Alias('Path')]
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string[]] $FullName
)

PROCESS {
    @($FullName) |% { [pscustomobject] @{ Path = $_ ; LineCount = @(Get-Content $_ |? { $_ -notmatch '^(?:\s*(?:;|\w+\:)|\s*$)' }).Count } }
}