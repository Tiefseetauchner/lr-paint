Remove-Item application*.zip

Get-ChildItem application* | ForEach-Object {
    $archName = $_.Name + ".zip"
    7z a -r $archName $_.Name
}