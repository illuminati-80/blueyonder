
#### Loop through the files in files.xml and logs the files which have been added/modified #############

$workdir="C:\Users\lappy\Desktop\jda\req3job"
$xmlfile0loc="$workdir\files0.xml.TXT"
$xmlfile1loc="$workdir\files1.xml.TXT"
$logfile="$workdir\logfilereq3_day2.txt"

#creating backup directory & log file
New-Item -Path $workdir -Name "backup_watcher" -ItemType "directory"
New-Item -Path "$logfile" -type File 

#retrieving file0.xml info 
$filedata_day0=[XML](Get-Content $xmlfile0loc)
$filedata_day1=[XML](Get-Content $xmlfile1loc)


$log="PROGRAM STARTS"
Out-File $logfile -Append -InputObject $log

###################### check for modified files ###########################

#take one file from files1.xml and loop through all files in files0.xml to find match and then comapare datamodified tag
foreach($fileloc1 in $filedata_day1.catalog.filelocation){
    $filepath1=$fileloc1.path
    $filedate1=$fileloc1.datemodified
    if(!(test-path $filepath1)){
        write-output ("["+ (Get-Date -Format "MM/dd/yyyy HH-mm-ss")+ "]-- "+$filepath1+" NOT FOUND") | Out-File $logfile -Append 
        Continue
    }
    $flag=$true
    foreach($fileloc0 in $filedata_day0.catalog.filelocation){
        $filepath0=$fileloc0.path
        $filedate0=$fileloc0.datemodified
        if(!(test-path $filepath0)){
            Continue
        }
        if($filepath0 -eq $filepath1){
            $flag=$false
            if($filedate1 -gt $filedate0){
                $file=Get-Item -Path $filepath0 | Select-Object Name, BaseName, Extension
                $newname=$file.BaseName+"_"+(Get-Date -Format "yyyy/MM/dd HH-mm-ss")+$file.Extension
                Copy-Item -Path $filepath1 -Destination $workdir\backup_watcher\$newname
                write-output ("["+ (Get-Date -Format "MM/dd/yyyy HH-mm-ss")+ "]-- "+$filepath1+" has been modified") | Out-File $logfile -Append 
            }
            else{
                write-output ("["+ (Get-Date -Format "MM/dd/yyyy HH-mm-ss")+ "]-- "+$filepath1+" has NOT been modified") | Out-File $logfile -Append
                
            }
            Break
        }
    }
    if($flag){
        write-output ("["+ (Get-Date -Format "MM/dd/yyyy HH-mm-ss")+ "]-- "+$filepath1+" is newly added") | Out-File $logfile -Append
        
    }
}



$log="DELETING FILE PROGRAM STARTS"
Out-File $logfile -Append -InputObject $log

############# check for deleted files ##############

foreach($fileloc0 in $filedata_day0.catalog.filelocation){
    $filepath0=$fileloc0.path
    if(!(test-path $filepath0)){
            write-output ("["+ (Get-Date -Format "MM/dd/yyyy HH-mm-ss")+ "]-- "+$filepath0+" NOT FOUND") | Out-File $logfile -Append 
            Continue
    }
    $flag=$true
    foreach($fileloc1 in $filedata_day1.catalog.filelocation){
        $filepath1=$fileloc1.path
        if(!(test-path $filepath1)){
            Continue
        }
        if($filepath0 -eq $filepath1){
            $flag=$false
            Break
        }
    }
    if($flag){
        write-output ("["+ (Get-Date -Format "MM/dd/yyyy HH-mm-ss")+ "]-- "+$filepath0+" has been deleted") | Out-File $logfile -Append
        #$log="{0} has been deleted"-f $filepath0
        #Out-File $logfile -Append -InputObject $log
    }
}




