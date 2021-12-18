#Search for and patch Log4j vuln in ALL jar files on machine
$host.ui.RawUI.BackgroundColor="Black"
$host.ui.RawUI.ForegroundColor="Blue"

Write-Host "Checking if 7-Zip is installed"
if (!(Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -like "7-Zip*"})) {
	$dlurl = 'https://7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' | Select-Object -ExpandProperty Links | Where-Object {($_.outerHTML -match 'Download')-and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} | Select-Object -First 1 | Select-Object -ExpandProperty href)
	$installerPath = Join-Path $env:TEMP (Split-Path $dlurl -Leaf)
	Invoke-WebRequest $dlurl -OutFile $installerPath
	Start-Process -FilePath $installerPath -Args "/S" -Verb RunAs -Wait
	Remove-Item $installerPath
}

Write-Host "Checking what drive letters are on machine..."
$drives=get-psdrive | Select-Object Root
Write-Host "Drives found:"
$fdrives=$drives.Root -match '^[A-Z]:\\'
$fdrives

Write-Host "Searching for jar files..."
$jars=@()
$vulnjars=@()

foreach ($fdrive in $fdrives) {
	Write-Host "Searching" $fdrive"..."
	$jars+=Get-ChildItem *.jar -Path $fdrive -Recurse -ErrorAction SilentlyContinue | Select-Object FullName
}

if ($null -eq $jars.FullName) {
	$host.ui.RawUI.ForegroundColor="DarkYellow"
	if ($jars.FullName.Count -gt 1) {
		Write-Host $jars.FullName.Count "jars found:" 
	} elseif ($jars.FullName.Count -eq 1) {
		Write-Host $jars.FullName.Count "jar found:"
	}
	$jars.FullName
} else {
	Write-Host "No jar files found... Exiting..."
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

if ($null -eq $vulnjars) {
	$host.ui.RawUI.ForegroundColor="Red"
	if ($vulnjars.Count -gt 1) {
		Write-Host $vulnjars.Count "vulnerable jars found:"
		$vulnjars
		$host.ui.RawUI.ForegroundColor="Magenta"
		Write-Host "Removing vulnerable class from" $vulnjars.Count "jars..."
	} elseif ($vulnjars.Count -eq 1) {
		Write-Host $vulnjars.Count "vulnerable jar found:"
		$vulnjars
		$host.ui.RawUI.ForegroundColor="Magenta"
		Write-Host "Removing vulnerable class from" $vulnjars.Count "jar..."
	}
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