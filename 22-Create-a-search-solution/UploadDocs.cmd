@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem Set values for your storage account
set subscription_id=9b544211-5391-485c-90a0-404a52724264
set azure_storage_account=adm3storage
set azure_storage_key=yVj7ko+mbNbEdQxWS/LjlFh1mpSYB7MJvVrtqnweWB/SQNQsgIfHfimnkNmlQgmlJ1MmzFcm1kUk+AStbS5DgA==


echo Creating container...
call az storage container create --account-name !azure_storage_account! --subscription !subscription_id! --name margies --public-access blob --auth-mode key --account-key !azure_storage_key! --output none

echo Uploading files...
call az storage blob upload-batch -d margies -s data --account-name !azure_storage_account! --auth-mode key --account-key !azure_storage_key!  --output none
