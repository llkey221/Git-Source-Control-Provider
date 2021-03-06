﻿

param (
    [string]$gitHubUsername = $null,
    [string]$gitHubRepository = $null,
    [string]$tagName = $null,
    [string]$gitHubApiKey = $null
)


 function DeleteRelease($releaseId)
 {
	 $deleteReleaseParams = @{
	   Uri = "https://api.github.com/repos/$gitHubUsername/$gitHubRepository/releases/$releaseId";
	   Method = 'DELETE';
	   Headers = @{
		  Authorization = 'token ' + $gitHubApiKey
	   }
	 }
	 $result = Invoke-RestMethod @deleteReleaseParams
	 Write-Host "Release Deleted"  
 }

 function DeleteTag($tag)
 {

	   $deleteTagParams = @{
	   Uri = "https://api.github.com/repos/$gitHubUsername/$gitHubRepository/git/refs/tags/$tag";
	   Method = 'DELETE';
	   Headers = @{
		 Authorization = 'token ' + $gitHubApiKey
	   }
		  ContentType = 'application/json';
	   Body = ""
	}
    Try
        {
			$result = Invoke-RestMethod @deleteTagParams 
			Write-Host "Tag Deleted"
        }
     
     Catch
        {
	      Write-Host "Tag Not Found"
        }

	
 }


if ($gitHubUsername.Length -eq 0) {
    Write-Host "Parameter -gitHubUsername was not provided, and is required."
    return
}

if ($gitHubRepository.Length -eq 0) {
    Write-Host "Parameter -gitHubRepository was not provided, and is required."
    return
}

if ($tagName.Length -eq 0) {
    Write-Host "Parameter -tagName was not provided, and is required."
    return
}
if ($gitHubApiKey.Length -eq 0) {
    Write-Host "Parameter -gitHubApiKey was not provided, and is required."
    return
}

 $getReleaseParams = @{
   Uri = "https://api.github.com/repos/$gitHubUsername/$gitHubRepository/releases/tags/$tagName";
   Method = 'GET';
   Headers = @{
     Authorization = 'token ' + $gitHubApiKey
   }
 }

$relId;

Try
{
	$release = Invoke-RestMethod @getReleaseParams 
	$relId = $release.id
}
Catch
{
	Write-Host "Release not found" 
	DeleteTag($tagName)
	Exit;
}

if (!$relId)
{
	Write-Host "Release ID not found" 
	DeleteTag($tagName)
	Exit;
}

DeleteRelease($relId)
Start-Sleep -s 3  
DeleteTag($tagName)
Start-Sleep -s 3  

 

 


  
