curl -X POST "https://cognitiveservicelearning3.cognitiveservices.azure.com//text/analytics/v3.1/languages?" -H "Content-Type: application/json" -H "Ocp-Apim-Subscription-Key: 6ab9d44b04154d23a373b0269e9847ef" --data-ascii "{'documents':[{'id':1,'text':'hello'}]}"