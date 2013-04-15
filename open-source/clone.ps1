Clear-Host
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath

Set-Location -Path $dir

[xml]$repos = Get-Content repositories.xml

$repos.repositories.repo | Foreach-Object {
	$repo = $_
	$type = $repo.type
	$name = $repo.name
	
	if (!(Test-Path $repo.name)) {
		$url = $repo.url
		$command = "clone"
		if ($type -eq "svn") {
			$command = "checkout"
		}
		
		$expression = "$type.exe $command --quiet $url $name"
		#Write-Host $expression
		Invoke-Expression $expression
	} else {
		$command = "pull"
		if ($repo.type -eq "svn") {
			$command = "update"
		}
		
		Set-Location -Path $repo.name
		$expression = "$type.exe $command --quiet"
		#Write-Host $expression
		Invoke-Expression $expression
		Set-Location -Path ".."
	}
}
