[CmdletBinding()]
param(
    [Alias('FullName','Path')]
    [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
    [string] $ExeFilePath,

    [Parameter(Position = 1)]
    [int] $InCount = 1,

    [Parameter(Position = 2, ValueFromPipeline)]
    [string[]] $InputValues = @(-2,-1,0,1,2)
)

BEGIN {
    $exeFile = Get-ChildItem $ExeFilePath
    $ExeFilePath = $exeFile.FullName
    
    $inputSets = @{}
    $index = 0
    $count = 0
}

PROCESS {
    @($InputValues) |% {
        if (-not $inputSets.ContainsKey($index)) { $inputSets[$index] = @() }
        $inputSets[$index] += @($_)

        if (++$count % $InCount -eq 0) { ++$index }
    }
}

END {
    $inputSets.Values.GetEnumerator() |% {
        @($_) |% { Write-Host -NoNewline -Fore Yellow "$_ " }
        Write-Host

        @($_) | & $ExeFilePath
        Write-Host
    }   
}