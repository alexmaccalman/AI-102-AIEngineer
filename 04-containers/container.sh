# create container instance
az container create --resource-group ResourceGroup1 --name ai27298245 --image mcr.microsoft.com/azure-cognitive-services/textanalytics/language:1.1.013570001-amd64 --dns-name-label aci-demo --ports 5000

# check status
az container show --resource-group ResourceGroup1 --name ai27298245 --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" --out table
