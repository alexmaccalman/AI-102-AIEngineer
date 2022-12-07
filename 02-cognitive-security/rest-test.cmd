yourEndpoint='https://cognitiveservicelearning2.cognitiveservices.azure.com/'
yourKey='55da9c2f039f4fc080c142fb6f74bb3a'
curl -X POST $yourEndpoint"/text/analytics/v3.1/languages?" -H "Content-Type: application/json" -H "Ocp-Apim-Subscription-Key: "$yourKey --data-ascii "{'documents':[{'id':1,'text':'hello'}]}"