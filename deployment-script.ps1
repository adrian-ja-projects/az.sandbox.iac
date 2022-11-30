#==================================================
# Script to release a new environment for assignment assessments
#
# AdrianJ / V1.0 / 2022-11
#===================================================
<#
  .SYNOPSIS
  Release a new environment with sta, dbw, kv, adf and sqldb for assignment

  .PARAMETER candidateID
  Candidate name or id

  .PARAMETER candidateAadObjectID
  Candidate user object id in Azure AAD

  .NOTES
  The script was design to be run manually locally. 
#>
param (
    [parameter(Mandatory = $true)] [string] $candidateID,
    [parameter(Mandatory = $true)] [string] $candidateAadObjectID
)

$azureSubscription = "ce07b563-1e18-4f13-aab3-d7db450b0d03"

Select-AzSubscription -SubscriptionId $azureSubscription #to-do silent output

#set candidate parameters
$dataFactoryName = "adf-de-assessment-$candidateID"
$keyVaultName = "kv-assessment-$candidateID"
$location = "westeurope"
$managedStorageAccountName = "stdbw$candidateID"
$resourceGroupName = "rg-de-assessment-$candidateID"
$storageAccountName = "sta$candidateID"
$sqlDBName = "sql-db-assessment-$candidateID"
$sqlServerName = "sql-server-assessment-$candidateID"
$deploymentName = "deployment-assessment-$candidateID"
$templateFilePath = ".\main.bicep"
$templateParameterFilePath = ".\main.parameters.json"

#get first date of month for budget date
$startDate = Get-Date -UFormat "%Y-%m"
$startDate = "$startDate-01"

#check if resource group exists 
$resourceGroupExists = Get-AzResourceGroup -name $resourceGroupName -ErrorAction SilentlyContinue

if ($null -ne $resourceGroupExists){
    Write-Error "Resource group $resourceGroupName exists!"
    Exit 1;
}

#replace parameters in parameters file
$templateContent = Get-Content -Path "_param_template\parameters_template.json";

$customerContent = $templateContent.Replace("REPLACE_WITH_ADF_NAME", $dataFactoryName);
$customerContent = $customerContent.Replace("REPLACE_WITH_CANDIDATE_ID", $candidateID);
$customerContent = $customerContent.Replace("REPLACE_WITH_CANDIDATE_OID", $candidateAadObjectID);
$customerContent = $customerContent.Replace("REPLACE_WITH_KV_NAME", $keyVaultName);
$customerContent = $customerContent.Replace("REPLACE_WITH_STA_DABRICKS_NAME", $managedStorageAccountName);
$customerContent = $customerContent.Replace("REPLACE_WITH_RG_NAME", $resourceGroupName);
$customerContent = $customerContent.Replace("REPLACE_WITH_STA_NAME", $storageAccountName);
$customerContent = $customerContent.Replace("REPLACE_WITH_SQL_DB_NAME", $sqlDBName);
$customerContent = $customerContent.Replace("REPLACE_WITH_SQL_SERVER_NAME", $sqlServerName);
$customerContent = $customerContent.Replace("REPLACE_WITH_START_DATE", $startDate);

$customerContent | Out-File "main.parameters.json";

#resource group deployment
New-AzDeployment `
-Name $deploymentName `
-Location $location `
-TemplateFile $templateFilePath `
-TemplateParameterFile $templateParameterFilePath