# this script use the local Dockerfile
param ([string][Parameter( Mandatory=$true)]$ResourceGroupName,
         [string][Parameter( Mandatory=$true)]$RegistryName)       

$RegistryName="rg-hack-france20"

#change with your registry name acrxxx
$registryname="acrhfra36"

$tag="$RegistryName.azurecr.io/testhack:latest"
az account clear
write-host "Sign in to Azure"
az login
write-host "Sign in to Azure Container Registry"
az acr login -n $registryname --expose-token #works !!!
write-host "Ask the registry to build the Images"
az acr build -t $tag -g $ResourceGroupName -r $RegistryName . --platform "linux"



#$passwordregistry=az acr credential show --resource-group $rgname --name $registryname --query passwords[0].value --output tsv

#$loginserver=az acr show -n $registryname --resource-group $rgname --query loginServer

#docker login $loginserver --username $registryname --password $passwordregistry


#docker push $tag
