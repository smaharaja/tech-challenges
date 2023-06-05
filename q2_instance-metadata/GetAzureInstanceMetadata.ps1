
# Challenge 2- Write code that will query the metadata of an instance within Azure and provide json formatted output.
# Bonus- Code allows for a particular data key to be retrieved individually.


function PrintInstanceInfo {
	param (
		[Parameter(Mandatory=$true)]
		[object]$objMetadata,
		
		[Parameter()]
		[string]$dataKey
	)
	
	# If Data Key Parameter Is Passed, Print Only Data Key Value Else Print Full Json
	if ($PSBoundParameters.ContainsKey("dataKey")) {
		Write-Host "******** Printing Instance Metadata **********"
		Write-Host "Data Key- $dataKey"
		#Write-Host $($objMetadata.compute.name)
		
		#If Nested Properties Are Requested Then Loop Through Them To Get Value
		if ($dataKey.Contains(".")) {
			$dataKeyObject = $objMetadata
			$props = $dataKey.Split('.')
			$props | ForEach-Object {
				$dataKeyObject = $dataKeyObject.$_
			}
			
			Write-Host "Data Key Value- $dataKeyObject"
		} 
		else {
			Write-Host "Data Key Value- $($objMetadata.$dataKey)"
		}
	
	}
	else {
		$json = $objMetadata | ConvertTo-Json -Depth 64
		Write-Host $json
	}
}

# Get The Response By Calling Microsoft Instance Metadata Service
$response = Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Proxy $Null -Uri "http://169.254.169.254/metadata/instance?api-version=2021-02-01"
	
### Testing Calls With Various Parameters
# Get All The JSON
PrintInstanceInfo $response

#Get Various Properties Of instance
#PrintInstanceInfo $response "compute"
PrintInstanceInfo $response "compute.name"
PrintInstanceInfo $response "compute.resourceGroupName"
PrintInstanceInfo $response "compute.vmSize"
PrintInstanceInfo $response "compute.tags"

#Get Private IP Of Instance
PrintInstanceInfo $response "network.interface.ipv4.ipAddress.privateIpAddress"
