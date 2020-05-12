function quitTeams() {
    $TeamsProcess = Get-Process -Name "Teams" -ErrorAction SilentlyContinue
    if ($TeamsProcess) {
        $TeamsProcess | Stop-Process -Force
        $TeamsProcess | Wait-Process
    }
}

$RootPath = $HOME

$CacheLocations =
($RootPath + '\AppData\Roaming\Microsoft\Teams\Application Cache'),
($RootPath + '\AppData\Roaming\Microsoft\Teams\blob_storage'),
($RootPath + '\AppData\Roaming\Microsoft\Teams\Cache'),
($RootPath + '\AppData\Roaming\Microsoft\Teams\databases'),
($RootPath + '\AppData\Roaming\Microsoft\Teams\GPUCache'),
($RootPath + '\AppData\Roaming\Microsoft\Teams\IndexedDB'),
($RootPath + '\AppData\Roaming\Microsoft\Teams\Local Storage'),
($RootPath + '\AppData\Roaming\Microsoft\Teams\tmp')

function deleteCache($CacheLocation) {
    Write-Host "Checking: $CacheLocation"
    $PathExists = Test-Path -Path $CacheLocation
    If ($PathExists) {
        Remove-Item -Force -Recurse -Path $CacheLocation\
        Write-Host "Clearing cache: $CacheLocation"
    }
    Else {
        Write-Host "Cache does not exist: $CacheLocation"
    }
}

function startTeams() {
    .$HOME\AppData\Local\Microsoft\Teams\Update.exe --processStart "Teams.exe"
}

quitTeams
Start-Sleep 10
ForEach ($path in $CacheLocations) {
    deleteCache($path)
}
Start-Sleep 10
startTeams