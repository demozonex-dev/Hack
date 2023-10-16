## 


$AADGroups=az ad group list --query "[?contains(displayName, 'hkt')].{id: id, displayName: displayName}" | ConvertFrom-Json

$id=az group show -g "rg-SharedData" --query id
$ResourceGroupName="rg-SharedData"

Foreach ($AADGroup in $AADGroups)
{
           
            if ($AADGroup.displayName -eq "hkt-datadesk")
            {
                continue
            }
            write-host $AADGroup.displayName
            # write-host "Applying RBAC to  the resource group  '$ResourceGroupName'"
            $AadGroupId=$AADGroup.id
            
            # az role assignment delete --resource-group $ResourceGroupName --assignee $AadGroupId --role "Storage Blob Data Contributor" --scope $id  --query roleDefinitionId
            # az role assignment delete --resource-group $ResourceGroupName --assignee $AadGroupId --role "Contributor" --scope $id  --query roleDefinitionId

            # az role assignment  create --resource-group $ResourceGroupName --assignee $AadGroupId --role "Storage Blob Data Reader" --scope $id  --query roleDefinitionId
            # az role assignment  create --resource-group $ResourceGroupName --assignee $AadGroupId --role "Reader" --scope $id  --query roleDefinitionId

            az role assignment delete  --assignee $AadGroupId --role "Storage Blob Data Contributor" --scope $id  --query roleDefinitionId
            az role assignment delete  --assignee $AadGroupId --role "Contributor" --scope $id  --query roleDefinitionId

            az role assignment  create  --assignee $AadGroupId --role "Storage Blob Data Reader" --scope $id  --query roleDefinitionId
            az role assignment  create  --assignee $AadGroupId --role "Reader" --scope $id  --query roleDefinitionId
            
            
}