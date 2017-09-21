[CmdletBinding()]
param(
    [Alias('Path')]
    [Parameter(Mandatory)]
    [string] $FullName
)

(Get-Content $FullName |? { $_ -notmatch '^(?:\s*(?:;|\w+\:)|\s*$)' }).Count