 echo "Running speedtest"

 $Speedtest = (.\speedtest.exe -f csv --output-header --accept-gdpr| ConvertFrom-Csv | ForEach-Object {
    $_.download = $_.download/125000
    $_.upload = $_.upload/125000
    
    $hash = [ordered]@{timestamp=(Get-Date -Format "MM/dd/yyyy HH:mm:ss")}
         $i = $_
         $_.psobject.properties |
             ForEach-Object{
                 
                 $hash.($_.Name) = $i.($_.Name)

             }

    [PSCustomObject]$hash
    } )
    
    <#
    $Speedtest | Select timestamp,download | Export-Csv -Path .\Download-speed.csv -NoTypeInformation -Append
    $Speedtest | Select timestamp,upload | Export-Csv -Path .\Upload-speed.csv -NoTypeInformation -Append
    $Speedtest | Select timestamp,jitter | Export-Csv -Path .\jitter.csv -NoTypeInformation -Append
    $Speedtest | Select timestamp,latency | Export-Csv -Path .\latency.csv -NoTypeInformation -Append
    $Speedtest | Select timestamp,'packet loss' | Export-Csv -Path .\packetloss.csv -NoTypeInformation -Append
    #>
    $Speedtest | Select timestamp,download,upload,jitter,latency,'packet loss' | Export-Csv -Path .\alldata.csv -NoTypeInformation -Append



    git pull
    git add .
    git commit -m poll
    git push
