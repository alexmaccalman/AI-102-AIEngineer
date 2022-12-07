id=0
az group create --name cognitive-services-resource-group --location eastus

az cognitiveservices account create --name cognitiveserviceslearning$id --resource-group cognitive-services-resource-group --kind CognitiveServices --sku S0 --location eastus --yes

az cognitiveservices account keys list  --name cognitiveserviceslearning$id --resource-group cognitive-services-resource-group

