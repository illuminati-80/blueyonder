$workdir="C:\Users\lappy\Desktop\jda\req3job"
$xmlfoldloc="$workdir\folders.xml.TXT"
$xmlfile0loc="$workdir\files0.xml.TXT"
$xmlfile1loc="$workdir\files1.xml.TXT"

#######################################     files0.xml   ################################### 

#creating load csv file with proper fields
$header="customername", "servername", "folderpath", "filename", "size", "modified"
$outfile0path="$workdir\output0.csv"
$newcsv0= {} | select $header | Export-Csv $outfile0path

#adding initial values to the csv 
$csvfile0=Import-csv $outfile0path
$csvfile0.customername="random initial value"
$csvfile0.servername="random Initial value"
$csvfile0.folderpath="random initial value"
$csvfile0.filename="random initial value"
$csvfile0.size="random initial value"
$csvfile0.modified="random initial value"

$csvfile0 | export-csv $outfile0path -NoTypeInformation


#retrieving file0 info 
$filedata0=[XML](Get-Content $xmlfile0loc)

#appending output0.csv file

foreach($filpath0 in $filedata0.catalog.filelocation){
    $fildir0=$filpath0.path
    $4colum=Get-ChildItem -Path $fildir0 | Select-Object BaseName,Length,LastWriteTime,FullName
    $colum1="custome_unknwn"
    $colum2="srver_unknown"

    #Write-Host $3row[$i].BaseName
    $colum3=$4colum.FullName
    $colum4= $4colum.BaseName
    $colum5= $4colum.Length/1024
    $colum6= $4colum.LastWriteTime
    $finalrow="$colum1,$colum2,$colum3,$colum4,$colum5,$colum6"
    $finalrow| Add-Content -Path $outfile0path 
    
}




##############files1.xml##########



#creating load csv file with proper fields
$header="customername", "servername", "folderpath", "filename", "size", "modified"
$outfile1path="$workdir\output1.csv"
$newcsv1= {} | select $header | Export-Csv $outfile1path


#adding initial values to the csv
$csvfile1=Import-csv $outfile1path
$csvfile1.customername="random initial value"
$csvfile1.servername="random Initial value"
$csvfile1.folderpath="random initial value"
$csvfile1.filename="random initial value"
$csvfile1.size="random initial value"
$csvfile1.modified="random initial value"

$csvfile1 | export-csv $outfile1path -NoTypeInformation



#retrieving file1 info 
$filedata1=[XML](Get-Content $xmlfile1loc)



foreach($filpath1 in $filedata1.catalog.filelocation){
    $fildir1=$filpath1.path
    $4colum=Get-ChildItem -Path $fildir1 | Select-Object BaseName,Length,LastWriteTime,FullName
    $colum1="custome_unknwn"
    $colum2="srver_unknown"

    #Write-Host $3row[$i].BaseName
    $colum3=$4colum.FullName
    $colum4= $4colum.BaseName
    $colum5= $4colum.Length/1024
    $colum6= $4colum.LastWriteTime
    $finalrow="$colum1,$colum2,$colum3,$colum4,$colum5,$colum6"
    $finalrow| Add-Content -Path $outfile1path 
    
}








#######################     REQ_3   ####################

$workdir="C:\Users\lappy\Desktop\jda\req3job"
$xmlfoldloc="$workdir\folders.xml.TXT"
$logfile="$workdir\logfile.txt"
$watchdir="N:\3-2\Reading Course"

#creating directory 
New-Item -Path $workdir -Name "backup_watcher" -ItemType "directory"

New-Item -Path "$logfile" -type File 

$filter="*.*"
$watcher=New-Object IO.FileSystemWatcher $watchdir, $filter -Property @{
    IncludeSubdirectories = $true
    EnableRaisingEvents=$true
}



$append_action={
    $path=$Event.SourceEventArgs.FullPath
    $name = $Event.SourceEventArgs.Name
    $FullPath=$Event.SourceEventArgs.FullPath
    $OldFullPath=$Event.SourceEventArgs.OldFullPath
    $OldName=$Event.SourceEventArgs.OldName
    $ChangeType = $Event.SourceEventArgs.ChangeType
    $TimeStamp = $Event.TimeGenerated
    #$console_message = "The file '$name' was '$changeType' at '$timeStamp'"
    #Write-Host $console_message
    $log = "$name, $ChangeType, $TimeStamp"
    Out-File $logfile -Append -InputObject $log

    if(($ChangeType -eq 'Changed') -OR ($ChangeType -eq 'Renamed')){
        Copy-Item -Path $FullPath -Destination $workdir\backup_watcher                
    }
}


Register-ObjectEvent $watcher Created -SourceIdentifier Created -Action $append_action
Register-ObjectEvent $watcher Changed -SourceIdentifier Changed -Action $append_action
Register-ObjectEvent $watcher Deleted -SourceIdentifier Deleted -Action $append_action
Register-ObjectEvent $watcher Renamed -SourceIdentifier Renamed -Action $append_action




Unregister-Event Created
Unregister-Event Changed
Unregister-Event Deleted
Unregister-Event Renamed






























