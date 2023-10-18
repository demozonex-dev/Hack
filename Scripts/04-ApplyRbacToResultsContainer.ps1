# param ([string][Parameter( Mandatory=$true)]$StorageName)

## 
$SubscriptionId=az account show --query id
$storage=az resource list -g rg-shareddata --query "[?type == 'Microsoft.Storage/storageAccounts'].{name: name}" | convertfrom-json
$StorageName=$storage.name
$scopeId="/subscriptions/$SubscriptionId/resourceGroups/rg-shareddata/providers/Microsoft.Storage/storageAccounts/$StorageName/blobServices/default/containers/results"



$AADGroups=az ad group list --query "[?contains(displayName, 'hkt')].{id: id, displayName: displayName}" | ConvertFrom-Json

Foreach ($AADGroup in $AADGroups)
{
           
            if ($AADGroup.displayName -eq "hkt-datadesk")
            {
                continue
            }
            write-host $AADGroup.displayName            
            $AadGroupId=$AADGroup.id            
            az role assignment create  --assignee $AadGroupId --role "Storage Blob Data Contributor" --scope $scopeId  --query roleDefinitionId
                                    
}