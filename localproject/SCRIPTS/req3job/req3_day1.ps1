

#### Loop through the files in files.xml and logs the files which have been added/modified #############

$workdir="C:\Users\lappy\Desktop\jda\req3job"
$xmlfile0loc="$workdir\files0.xml.TXT"
$xmlfile1loc="$workdir\files1.xml.TXT"
$logfile="$workdir\logfilereq3_day1.txt"

#creating backup directory & log file
New-Item -Path $workdir -Name "backup_day1" -ItemType "directory" -ErrorAction SilentlyContinue
New-Item -Path "$logfile" -type File -ErrorAction SilentlyContinue

#retrieving file0.xml info 
$filedata_day1=[XML](Get-Content $xmlfile1loc)


$log="PROGRAM STARTS"
Out-File $logfile -Append -InputObject $log

#loop through files.xml and save the files which have been modified
foreach($fileloc in $filedata_day1.catalog.filelocation){
    $filepath=$fileloc.path
    if(!(test-path $filepath)){
        write-output ("["+ (Get-Date -Format "MM/dd/yyyy HH-mm-ss")+ "]-- "+$filepath+" has been deleted") | Out-File $logfile -Append
        Continue
    }

    $fileprop= Get-ChildItem -Path $filepath | Select-Object LastWriteTime, CreationTime, Name, Basename, Extension
    #ts stores -1 day inorder to compare fileproperties with previous data
    $ts = New-TimeSpan -Days -1 

    if($fileprop.CreationTime -gt ((Get-Date) + $ts)){
        $changetype='created or renamed'
        #$log = "{0} was {1} at {2}" -f $fileprop.name, $changetype, (get-date)
        #Out-File $logfile -Append -InputObject $log
        write-output ("["+ (Get-Date -Format "MM/dd/yyyy HH-mm-ss")+ "]-- "+$fileprop.name+" was "+ $changetype) | Out-File $logfile -Append
    }
    elseif($fileprop.LastWriteTime -gt ((Get-Date) + $ts)) {
        
        $newname=$fileprop.BaseName+"_"+(Get-Date -Format "MM/dd/yyyy HH-mm-ss")+$fileprop.Extension
        Copy-Item -Path $filepath -Destination $workdir\backup_day1\$newname
        $changetype='modified'
        #$log = "{0} was {1} at {2}" -f $fileprop.name, $changetype, (get-date)
        #Out-File $logfile -Append -InputObject $log
        write-output ("["+ (Get-Date -Format "MM/dd/yyyy HH-mm-ss")+ "]-- "+$fileprop.name+" was "+ $changetype) | Out-File $logfile -Append

    }
    else{
        
        write-output ("["+ (Get-Date -Format "MM/dd/yyyy HH-mm-ss")+ "]-- "+$fileprop.name+" was NOT modified") | Out-File $logfile -Append
    }
    write-host $fileprop
    
}

    
###############################################