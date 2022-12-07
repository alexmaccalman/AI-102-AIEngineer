KEYVAULTNAME='cogvault2'
RESOURCEGROUP='cognitive-services-resource-group'
SUB='2f78ceb9-79f5-498a-9b7f-ee988acaa038'
APP_ID="01d15048-e325-4afa-b280-cc580884338d"

az keyvault create --name $KEYVAULTNAME --resource-group $RESOURCEGROUP --location "EastUS"

 az ad sp create-for-rbac -n "api://spcognitive" --role owner --scopes subscriptions/$SUB/resourceGroups/$RESOURCEGROUP

az ad sp show --id $APP_ID --query objectId --out tsv

az keyvault set-policy -n $KEYVAULTNAME --object-id 6a29cce7-8dde-46bd-ad2e-6c7b7db8813f --secret-permissions get list