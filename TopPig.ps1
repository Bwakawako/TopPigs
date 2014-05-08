param ([string]$Path=(pwd), [int]$HeadNumber=10)

Function GetDirectorySize([string]$Path)
{
    $result = Get-ChildItem -Force -Path $Path | Measure-Object Length -Sum -ErrorAction Ignore
    if ($result -eq $null)
    {
        return 0
    }
    return $result.Sum
}

$Directories = @{}

dir -Path $Path -Recurse -Force |? { $_.PSIsContainer -eq $True } |% { $Directories.Add($_.FullName, (GetDirectorySize $_.FullName) / 1000000)  }

"Taille en Mo"

#TODO Script block : { $_.Value }. COmment ca marche?
$Directories.GetEnumerator() | Sort-Object { $_.Value } -Descending | Select-Object -First $HeadNumber | Format-Table -Property Key, Value -AutoSize