

$workdir="C:\Users\lappy\Desktop\jda"

#creating finaloutput file3 
$outputfilename="file3_"+ (get-date -Format "yyyy/MM/dd HH-mm-ss") + ".csv"
$file3path="$workdir\$outputfilename"
$header=@('"Customer_Name","Server_Name","Folder_Path","File_Name","Size (kb)","Modified","Modified_Type"')
Add-Content -path $file3path -Value $header


#searching and storing 2 recent output files
$filelist=Get-ChildItem -Path $workdir -Recurse -Include output_* |  Select-Object fullname, basename | Sort-Object -Property BaseName -Descending
$file1=Import-Csv -path $filelist[1].fullname | sort File_Name -Descending
$file2=Import-Csv -path $filelist[0].fullname | sort File_Name -Descending

$propsToCompare='File_Name' 

#storing files not found in either of the files 
$Results= Compare-Object  $File1 $File2 -Property $propsToCompare | Select-Object -ExpandProperty $propsToCompare

#appending modified files info from file 2 to file3
$file2 | Where-Object {$_.$propsToCompare -notin $Results} |  Select-Object *,@{Name='Modified_Type';Expression={'U'}}  | export-csv -Path $file3path -Append

#appending created files info from file 2 to file3
$file2 | Where-Object {$_.$propsToCompare -in $Results} | Select-Object *,@{Name='Modified_Type';Expression={'A'}} | export-csv -Path $file3path -Append 

#appending deleted files info from file 1 to file3
$file1 | Where-Object {$_.$propsToCompare -in $Results} | Select-Object *,@{Name='Modified_Type';Expression={'D'}} | export-csv -Path $file3path -Append 





############################################


$Array = @()       
Foreach($R in $Results)
{
    If( $R.sideindicator -eq "==" )
    {
        $Object = [pscustomobject][ordered] @{
            
            Customer_Name="custome_unknwn"
            Server_Name="srver_unknown"
            Folder_Path=$R.Folder_Path
            File_Name=$R.File_Name
            Size (kb)=$R.Size (kb)
            Modified=$R.Modified
            Modification_Type
            Username = $R.SamAccountName
            "Compare indicator" = $R.sideindicator
 
        }
        $Array += $Object
    }
    else if($R.sideindicator -eq "<="){
        
    }
    else{
        
    }
}