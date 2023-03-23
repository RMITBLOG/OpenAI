<#
    .NOTES
    ===========================================================================
     Created on:     18/03/2023 14:49
     Created by:    Ryan Mangan
     Organization:  Ryanmangansitblog ltd 
     Filename:       AIPSDiagTest.ps1
    ===========================================================================
    .DESCRIPTION
    This is a sample scriot
#>
<#
.SYNOPSIS
    This script demonstrates how to use the PowerShell.AIDiag module to interact with OpenAI API.

.DESCRIPTION
    This script imports the PowerShell.AIDiag module, creates an Auth object, and then prompts the user to input a question.
    The question is passed to the Get-Response function to obtain an answer from the OpenAI API. The response is then displayed on the console.

.EXAMPLE
    PS> .\YourScriptName.ps1

    This example shows how to run the script from the PowerShell console. Replace "YourScriptName.ps1" with the actual name of your script.

.NOTES
    - Make sure to update the $ApiKey variable with your actual API key.
    - Update the $ApiUrl variable with the appropriate API URL for your deployment.
    - You need the PowerShell.AIDiag.psm1 module in the same directory as your script for the Import-Module command to work.
#>
$PSScriptRoot
Import-Module .\PowerShell.AIDiag.psm1

# Set your API key and API URL

$env:MY_API_KEY = "KEY"

$ApiKey = $env:MY_API_KEY
$ApiUrl = "https://<Instance>.openai.azure.com/openai/deployments/<Model>/completions?api-version=2022-12-01"

# Create the Auth object
$auth = New-Auth -ApiKey $apiKey -ApiUrl $apiUrl

# Your PowerShell script goes here
# For example, this cmdlet could potentially fail if the file doesn't exist:

#try
#{
#	Get-Content C:\NonExistentFile.txt -ErrorAction Stop 
#}
#catch
#{
#	Handle-Error $_
#}

try {Get-Content C:\NonExistentFile.txt -ErrorAction Stop} catch {Handle-Error $_}
