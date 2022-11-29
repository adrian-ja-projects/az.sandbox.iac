param administratorLogin string
@secure()
param administratorLoginPassword string
param budgetAmount int
param dataFactoryName string
param databricksManagedIdentityName string
param candidateID string
param candidateAadObjectID string
param contactEmails array
param environmentType string
param keyVaultName string
param location string
param managedStorageAccountName string
param resourceGroupName string
param storageAccountName string
param sqlDBName string
param sqlServerName string
param startDate string
param thresholdBudget int

var budgetName = 'consumption-budget-${candidateID}'

targetScope = 'subscription'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
  tags : {
    environmentType : environmentType
  }
}

module key_vault_module 'modules/kv-de-assignment-mod.bicep' = {
  name: 'keyVault'
  scope: resourceGroup
  params: {
    keyVaultName: keyVaultName
    location: location
  }
}

module storage_account_module 'modules/stga-assesment-de-mod.bicep' = {
  name: 'storageAccount'
  scope: resourceGroup
  params: {
    storageAccountName: storageAccountName
    location: location
    candidateID: candidateID
  }
}

module data_factory_module  'modules/adf-de-assesment-mod.bicep' = {
  name: 'dataFactory'
  scope: resourceGroup
  params: {
    dataFactoryName: dataFactoryName
    location: location
  }
}

module dbw_module 'modules/dbw-de-assignment.bicep' = {
  name: 'databricksWorkspace'
  scope: resourceGroup
  params: {
    location: location
    candidateID: candidateID
    managedStorageAccountName: managedStorageAccountName
  }
}

module sqlServer_module 'modules/sql-de-assesment-mod.bicep' = {
  name: 'sqlServer'
  scope: resourceGroup
  params: {
    location: location
    administratorLogin: administratorLogin 
    administratorLoginPassword: administratorLoginPassword
    sqlDBName: sqlDBName
    sqlServerName: sqlServerName
  }
}

module permission_modules 'modules/perm-de-assesment-mod.bicep' = {
  name: 'permissions'
  scope: resourceGroup
  params: {
    candidateAadObjectId: candidateAadObjectID
    dataFactoryName: dataFactoryName
    databricksManagedIdentityName: databricksManagedIdentityName
    keyVaultName: keyVaultName
    storageAccountName: storageAccountName
  }
  dependsOn: [
    key_vault_module
    storage_account_module
    data_factory_module
    dbw_module
    sqlServer_module
  ]
}

//warning budget? 25eur
resource rgAssesmentBudget 'Microsoft.Consumption/budgets@2021-10-01' =  {
  name: budgetName
  properties: {
    amount: budgetAmount
    category: 'Cost'
    timeGrain: 'Monthly'
    timePeriod: {
      startDate: startDate
    }
    notifications: {
      NotificationForExceedBudget: {
        contactEmails: contactEmails
        enabled: true
        operator: 'GreaterThanOrEqualTo'
        threshold: thresholdBudget
      }
    }
    filter: {
      dimensions: {
        name: resourceGroupName
        operator: 'In'
        values: [
          resourceGroupName
        ]
      }
    }
  }
}
