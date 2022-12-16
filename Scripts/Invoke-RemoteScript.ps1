<#
.SYNOPSIS
	Runs a command stored on a remote URL.
.DESCRIPTION
	Downloads the command stored at the specified URL in the user's temporary folder, runs and delete.
.PARAMETER URL
	The Uniform Resource Locator where the command is stored.
.PARAMETER Parameters
	Parameters to be passed to the command.
#>
param
(
	[Parameter(Mandatory, HelpMessage = "The Uniform Resource Locator where the command is stored.")]
	[string]$URL,
	[Parameter(HelpMessage = "Parameters to be passed to the command.")]
	[string]$Parameters
)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
$scriptName = $URL.Substring($url.LastIndexOf("/") + 1)
$scriptTempPath = Join-Path $env:TEMP $scriptName
Invoke-WebRequest -Uri $URL -OutFile $scriptTempPath
if ($Parameters) { $scriptTempPath + " " + $Parameters }
& $scriptTempPath
Remove-Item $scriptTempPath