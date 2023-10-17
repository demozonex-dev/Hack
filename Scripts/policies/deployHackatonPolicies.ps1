#to run locally : 
#  - install git command line
#  - run the following command as admin user on windows to install Azure powershelle module : 
#               Install-Module -Name Az -Repository PSGallery -Force -AllowClobber
#               Connect-AzAccount
#  
# or run this script from a azure shell (but take care of deconnection timeout)


#### Settings section
$rgScanPrefix = "rg-hkt-"

# to retieve parameter value use the (Get-AzPolicyAssignment -scope $rg.ResourceId)[INDEXOFPOLICY].Properties.Parameters | ConvertTo-Json
#### Retrieving built-in policy definitions
Write-host "--->>> Retrieving policy definition for allowed VM SKUs ..."
$PolicyVmSkuSize = Get-AzPolicyDefinition | Where-Object { $_.Properties.DisplayName -eq 'Allowed virtual machine size SKUs' }
Write-Host "VM SKU Size :  PolicyDefinitionId = " $PolicyVmSkuSize.PolicyDefinitionId

Write-host "--->>> Retrieving policy definition for not allowed resource type ..."
$PolicyBlockedResourceType = Get-AzPolicyDefinition | Where-Object { $_.Properties.DisplayName -eq 'Not allowed resource types' }
Write-Host "BlockedResourceType :  PolicyDefinitionId = " $PolicyBlockedResourceType.PolicyDefinitionId

#### retrieving hackating resourcegroup
Write-Host "--->>> retrieving hackaton target resourceGroup ...."
$targetRgs = Get-AzResourceGroup | Where-Object { $_.ResourceGroupName.toLower().StartsWith($rgScanPrefix) }
Write-Host $targetRgs.Count " deployment to execute in :"
foreach($rg in $targetRgs)
{
        Write-Host "  -" $rg.ResourceGroupName "in" $rg.Location
}

#### applying policy on resource group
foreach($rg in $targetRgs)
{
        Write-Host "--->>> Applying policies on " $rg.ResourceGroupName "[" $rg.Location "]"
        Write-Host "    Resource ID =" $rg.ResourceId

        $assignName = 'Allowed vm size for hackaton RG ' + $rg.ResourceGroupName 
        New-AzPolicyAssignment -Name $assignName `
            -Scope $rg.ResourceId `
            -PolicyDefinition $PolicyVmSkuSize `
            -PolicyParameter .\allowedVmSkuPolicyParameter.json

        $assignName = 'Not allowed ResourceType for hackaton RG ' + $rg.ResourceGroupName 
        New-AzPolicyAssignment -Name $assignName `
            -Scope $rg.ResourceId `
            -PolicyDefinition $PolicyBlockedResourceType `
            -PolicyParameter .\notAllowedResourceTypePolicyParameter.json
}

Write-Host "--->>> Hackaton policies applied . Please check and verify console output and azure portal "

