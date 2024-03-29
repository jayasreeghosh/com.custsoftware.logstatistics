#Script to Extract Cannot resolve row and Coressponding un resolved full name  from source file.

param(
    [string]$arg1,
    [string]$arg2
)
 
Write-Output $arg1

#configure path as per your environment
$input_file = $arg1 -replace '@',' '
$input_path = $input_file
$final_file = $arg2+'\missingSource'+'_'+ (get-date -f yyyy_MM_dd_HH_mm_ss)+'.csv'
$intoutput_file = $arg2+�\unresolve.txt�
$joutput_path = $arg2+�\javaout.txt�

#Refrence pattern please get assitance before modification not required.
#$regex = �Cannot resolve\s*([^\n\r]*)�
$regex = �as package or type in package\s*([^\n\r]*)�
$regexsearchkey = �Cannot resolve+\s*(\S+)\w+�
$regexsource = �[^\s]+[A-Z]+\w+\.java�
$regexclass = �[^\s]+[A-Z]+\w+\.class�
$pkgpattern = �as package or type in package+\s*(\S+)\w+�
$srcpattern = �import.*�
$resolve = @()


select-string -Path $input_path -Pattern $regex -AllMatches | % { $_.Matches } | % { $_.Value } > $intoutput_file

#Intialize CSV file
Add-Content -Path $final_file  -Value '"SearchKey","Source","Ref Fullname"'

$data = Get-Content $intoutput_file
write-host $data.count total lines read from file
foreach ($line in $data)
{
	$varsearch=($line | Select-String -Pattern $pkgpattern -AllMatches | %{$_.Matches} | %{$_.Value})
	write-host $data.count total lines read from file
	$varsource=($line | Select-String -Pattern $regexsource,$regexclass -AllMatches | %{$_.Matches} | %{$_.Value})
	$varsearchkey = ($varsearch -replace "as package or type in package '", "")
   if ($varsource.length -gt 4)
   {
        select-string -Path $varsource -Pattern $varsearchkey -AllMatches | % { $_.Matches } | % { $_.Value } > $joutput_path
		$jdata = Get-Content $joutput_path
		foreach ($jline in $jdata)
			{
				$fullnameexist = ($jline | Select-String  $varsearchkey -AllMatches | %{$_.Matches} | %{$_.Value}) 
				if ($fullnameexist.length -gt 2) {
					 $fullnamesource =($jline -replace "import", "")
					#write-host $fullnamesource
				}
			}
	
	
    }
		#$src = Get-Content $varsource
		#$fullnamesource = ($src | Select-String  $varsearchkey -AllMatches | %{$_.Matches} | %{$_.Value})
  
	#write-host $varsource
	#write-host $varsearch
	$resolve += @(
		 $varsearchkey+',', $varsource+',' , $varsearchkey 
	  
  )
    

} 

$resolve | foreach { Add-Content -Path  $final_file -Value $_ }

