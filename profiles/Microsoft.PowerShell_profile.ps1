# $env:PSModulePath = $env:PSModulePath + "$([System.IO.Path]::PathSeparator)C:\Users\taeuks\Documents\WindowsPowerShell\Modules"	

Import-Module posh-git
Import-Module oh-my-posh
#Set-Theme Paradox
function greatlakes {ssh "taeuks@greatlakes.arc-ts.umich.edu"}

function gitimport {
	$reponame = Read-Host -Prompt "Enter the name of the GitHub repo to import:"
	$repourl = "git@github.com:taeukseo/" + $reponame + ".git"
	git clone $repourl
}
