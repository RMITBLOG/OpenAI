<#
		===========================================================================
		 Created on:   	18/03/2023 14:49
		 Created by:   	Ryan Mangan
		 Organization: 	Ryan Mangansitblog
		 Filename:     	PowerShell.AIDiag.psm1
		-------------------------------------------------------------------------
		 Module Name: PowerShell.AIDiag
		===========================================================================
	#>
	
	Add-Type -Path "OpenAISimpleMessage.dll"
	Add-Type -Path "HtmlAgilityPack.dll"
	
	<#
	.SYNOPSIS
	    Creates a new Auth object for interacting with the OpenAI API.
	
	.DESCRIPTION
	    The New-Auth function creates a new Auth object for the OpenAI API using the provided API key and API URL. This object can be used to interact with the API using the Get-Response function.
	
	.PARAMETER ApiKey
	    The API key for the OpenAI API.
	
	.PARAMETER ApiUrl
	    The API URL to send requests to.
	
	.EXAMPLE
	    $apiKey = "your_api_key"
	    $apiUrl = "https://api.openai.com/v1/engines/davinci-codex/completions" Or Azure https://<Name>.openai.azure.com/openai/deployments/<Name>/completions?api-version=2022-12-01
	    $auth = New-Auth -ApiKey $apiKey -ApiUrl $apiUrl
	
	    This example creates a new Auth object using the provided API key and API URL.
	
	.NOTES
	    - Ensure you have a valid API key for the OpenAI API.
	    - The API URL should be properly formatted and point to the correct endpoint for your API deployment.
	#>
	function new-auth
	{
		param (
			[Parameter(Mandatory = $true, HelpMessage = "The API key for the API.")]
			[string]$ApiKey,
			[Parameter(Mandatory = $true, HelpMessage = "The API URL to send requests to.")]
			[string]$ApiUrl
		)
		
		$auth = New-Object Auth($ApiKey, $ApiUrl)
		return $auth
	}
	
	
	<#
	.SYNOPSIS
	    Retrieves a response from the OpenAI API based on a given prompt.
	
	.DESCRIPTION
	    The Get-Response function sends a request to the OpenAI API using the provided Auth object and prompt, and returns the generated response. You can also specify optional parameters to customize the response.
	
	.PARAMETER Auth
	    The Auth object created using New-Auth function.
	
	.PARAMETER Prompt
	    The text prompt to send to the OpenAI API.
	
	.PARAMETER MaxTokens
	    The maximum number of tokens in the generated response (default: 100).
	
	.PARAMETER Temperature
	    Controls the randomness of the response (default: 0.7).
	
	.PARAMETER FrequencyPenalty
	    Penalizes new tokens based on their frequency in the training data (default: 0).
	
	.PARAMETER PresencePenalty
	    Penalizes new tokens based on their presence in the prompt (default: 0).
	
	.PARAMETER TopP
	    Controls the probability of sampling the tokens (default: 1).
	
	.PARAMETER BestOf
	    Controls how many responses the API should generate before selecting the best one (default: 1).
	
	.EXAMPLE
	    $apiKey = "your_api_key"
	    $apiUrl = "https://api.openai.com/v1/engines/davinci-codex/completions" Or Azure https://<Name>.openai.azure.com/openai/deployments/<Name>/completions?api-version=2022-12-01
	    $auth = New-Auth -ApiKey $apiKey -ApiUrl $apiUrl
	    $prompt = "What is an IP address?"
	    $response = Get-Response -Auth $auth -Prompt $prompt
	
	    This example sends a request to the OpenAI API with the given prompt and returns the generated response.
	
	.NOTES
	    - Ensure you have a valid Auth object before using this function.
	    - Customize the optional parameters to control the behavior of the API response.
	#>
	function Get-Response
	{
		param (
			[Parameter(Mandatory = $true, HelpMessage = "The Auth object created using New-Auth function.")]
			[object]$Auth,
			[Parameter(Mandatory = $true, HelpMessage = "The text prompt to send to the OpenAI API.")]
			[string]$Prompt,
			[int]$MaxTokens = 1000,
			[double]$Temperature = 0.7,
			[double]$FrequencyPenalty = 0,
			[double]$PresencePenalty = 0,
			[double]$TopP = 1,
			[int]$BestOf = 1
		)
		
		$response = $Auth.GetResponse($Prompt, $MaxTokens, $Temperature, $FrequencyPenalty, $PresencePenalty, $TopP, $BestOf)
		return $response
	}
	
	
	<#
	.SYNOPSIS
	Extracts the plain text content from a web page and saves it to a file.
	
	.DESCRIPTION
	The Extract-WebPage function extracts the plain text content from a web page and saves it to a file. The function uses OpenAI's Simple Message Extractor API to extract the content.
	
	.PARAMETER Url
	The URL of the web page to extract the content from.
	
	.PARAMETER OutputFile
	The file path and name to save the extracted content to.
	
	.EXAMPLE
	PS C:\> Extract-WebPage -Url "https://www.example.com" -OutputFile "C:\example.txt"
	
	This command extracts the plain text content from https://www.example.com and saves it to C:\example.txt.
	
	.NOTES
	This function requires an internet connection to use the OpenAI Simple Message Extractor API. This function should be used to extract plan text from websites for use with ChatGPT.
	
	
	#>
	function Extract-WebPage
	{
		[CmdletBinding()]
		param (
			[Parameter(Mandatory = $true)]
			[string]$Url,
			[Parameter(Mandatory = $true)]
			[string]$OutputFile
		)
		
		try
		{
			$content = [OpenAISimpleMessage.Extractor]::ExtractPlainTextAsync($Url).Result
			$content = $content -replace '\s+', ' '
			[System.IO.File]::WriteAllText($OutputFile, $content)
			Write-Host "Web page content saved to $OutputFile"
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
	
	function Handle-Error
	{
		param (
			[Parameter(Mandatory = $true)]
			[System.Management.Automation.ErrorRecord]$ErrorRecord
		)
		
		$errorMessage = "An error occurred: $($ErrorRecord.Exception.Message)"
		$truncatedErrorMessage = $errorMessage.Substring(0, [Math]::Min(100, $errorMessage.Length))
		
		# Escape the prompt and remove newline characters and double quotes
		$escapedPrompt = $truncatedErrorMessage.Replace("`"", "").Replace("\", "\\").Replace("`r", "").Replace("`n", "")
		
		$response = Get-Response -Auth $auth -Prompt $escapedPrompt
		write-output "****************"
		Write-Output "Error: "
		Write-Output "****************"
		Write-Output ($truncatedErrorMessage)
		Write-Output ("--- Error Diagnosis ---" + $response)
		write-output "---------------"
	}
	
	
	
	
	
	Export-ModuleMember -Function New-Auth, Get-Response, Extract-WebPage, Handle-Error
	
