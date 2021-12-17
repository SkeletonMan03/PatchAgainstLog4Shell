#Search for and patch Log4j vuln in ALL jar files on machine
$host.ui.RawUI.BackgroundColor="Black"
$host.ui.RawUI.ForegroundColor="Blue"
Write-Host "Searching for Jar files..."
$jars=@()
$jars = Get-ChildItem *.jar -Path C:\ -Recurse -ErrorAction SilentlyContinue | select FullName
$vulnjars=@()
if ($jars.FullName -ne $null) {
	$host.ui.RawUI.ForegroundColor="DarkYellow"
	Write-Host "Jars found:"
	$jars.FullName
} else {
	$host.ui.RawUI.ForegroundColor="Blue"
	Write-Host "No jar files found on system... Exiting"
	exit 0
}
foreach ($jar in $jars.FullName) {
		$host.ui.RawUI.ForegroundColor="Blue"
		Write-Host "Checking" $jar"..."
		$testing = & "C:\Program Files\7-Zip\7z.exe" l $jar JndiLookup.class -r
		if ($testing -match 'org\\apache\\logging\\log4j\\core\\lookup\\JndiLookup.class') {
			$vulnjars += $jar
		}
}
if ($vulnjars -ne $null) {
	$host.ui.RawUI.ForegroundColor="Red"
	Write-Host "Vulnerable jars found:"
	$vulnjars
	$host.ui.RawUI.ForegroundColor="Magenta"
	Write-Host "Removing vulnerable class from jars..."
	foreach ($vulnjar in $vulnjars) {
		Write-Host "Removing vulnerable class from" $vulnjar"..."
		& "C:\Program Files\7-Zip\7z.exe" d -tzip $vulnjar "JndiLookup.class" -r | Out-Null
	}
	$host.ui.RawUI.ForegroundColor="Green"
	Write-Host "Done patching!"
} else {
	$host.ui.RawUI.ForegroundColor="Green"
	Write-Host "No vulnerable jars were found!"
}
$host.ui.RawUI.ForegroundColor="Gray"