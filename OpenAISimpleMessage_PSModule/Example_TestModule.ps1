<#
    .NOTES
    ===========================================================================
     Created on:     18/03/2023 14:49
     Created by:    Ryan Mangan
     Organisation:  Ryanmangansitblog ltd 
     Filename:       Test-Module.ps1
    ===========================================================================
    .DESCRIPTION
    This is a sample script
#>
<#
.SYNOPSIS
    This script demonstrates how to use the OpenAISimpleMessage module to interact with OpenAI API.

.DESCRIPTION
    This script imports the OpenAISimpleMessage module creates an Auth object and then prompts the user to input a question.
    The question is passed to the Get-Response function to obtain an answer from the OpenAI API. The response is then displayed on the console.

.EXAMPLE
    PS> .\YourScriptName.ps1

    This example shows how to run the script from the PowerShell console. Replace "YourScriptName.ps1" with the actual name of your script.

.NOTES
    - Make sure to update the $ApiKey variable with your actual API key.
    - Update the $ApiUrl variable with the appropriate API URL for your deployment.
    - You need the OpenAISimpleMessage.psm1 module in the same directory as your script for the Import-Module command to work.
#>
Import-Module .\OpenAISimpleMessage.psm1

$ApiKey = "<Enter API Key>"
$ApiUrl = "<Enter API URL>"

$auth = New-Auth -ApiKey $apiKey -ApiUrl $apiUrl

$prompt = Read-Host -Prompt "Please enter your question"
$response = Get-Response -Auth $auth -Prompt $prompt

Write-Output $response


Extract-WebPage -Url "https://learn.microsoft.com/en-us/azure/app-service/overview" -OutputFile "output.txt"
