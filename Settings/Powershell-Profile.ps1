function Import-LocalModule([string]$modulePath) {
	<#
		.SYNOPSIS
		Imports local module
	#>
	if (Test-Path $modulePath) {
		Import-Module $modulePath
		return $true
	}
	return $false
}
if (Import-LocalModule "~\Source\Repos\Set-ConsoleSettings\Set-ConsoleSettings.psd1") {
	Set-ConsoleConfiguration -ShowInfo # Set console settings
}