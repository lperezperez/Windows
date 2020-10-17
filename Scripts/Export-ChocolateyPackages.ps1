<#
.SYNOPSIS
Exports the installed Chocolatey packages list.
.DESCRIPTION
Creates or updates "..\Settings\packages.config" file referencing all the installed packages for deployment.
.NOTES
The result "packages.config" file can be deployed by executing the follow sentence:
    choco ..\Settings\install packages.config
#>
$packagesConfig = New-Object System.IO.StreamWriter $(Join-Path $PSScriptRoot "..\Settings\packages.config")
$packagesConfig.WriteLine("<?xml version=`"1.0`" encoding=`"utf-8`"?>")
$packagesConfig.WriteLine("<packages>")
clist -lo -r | ForEach-Object { $packagesConfig.WriteLine("`t<package id=`"$($_.SubString(0, $_.IndexOf("|")))`"/>") }
$packagesConfig.Write("</packages>")
$packagesConfig.Close()