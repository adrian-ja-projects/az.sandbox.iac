param dataFactoryName string
//param databricksWorkspaceName string
param keyVaultName string
param storageAccountName string
param sqlServerName string
param sqlDBName string
param candidateAadObjectId string

var sievoDataEngineeringEngineeringAadObjectId = 'tbd'
var azureDevopsPipelineAgentObjectId = 'tbd'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageAccountName
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

//databricks managed identity
// resource databrickWorkspace 'Microsoft.Databricks/workspaces@2022-04-01-preview' existing = {
//   name: databricksWorkspaceName 
// }

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' existing = {
  name: sqlServerName
}

resource sqlDB 'Microsoft.Sql/servers/databases@2022-05-01-preview' existing = {
  name: sqlDBName
}

resource keyVaultAccessPolicies 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  parent: keyVault
  name: 'add'
  properties: {
    accessPolicies: [
      {
        objectId: azureDevopsPipelineAgentObjectId
        permissions: {
          secrets: [
            'list'
            'get'
            'set'
          ]
        }
        tenantId: subscription().id
      }
      {
        objectId: dataFactory.identity.principalId
        permissions: {
          secrets: [
            'get'
          ]
        }
        tenantId: subscription().tenantId
      }
      {
        objectId: sievoDataEngineeringEngineeringAadObjectId
        permissions: {
          secrets: [
            'get'
          ]
        }
        tenantId: subscription().tenantId
      }
      {
        objectId: candidateAadObjectId
        permissions:{
          secrets: [
            'get'
            'list'
            'set'
          ]
        }
        tenantId: subscription().tenantId
      }
      // Databricks managed identity
      // {
      //   objectId: //databrickWorkspace.identity.principalId
      //   permissions: {
      //     secrets: [
      //       'get'
      //     ]
      //   }
      //   tenantId : subscription().tenantId
      // }
    ]
  }
}

@description('Assigns the users to Storage Blob Data Contributor Role for the adls in the resource group')
resource userRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: 
  properties: {
    principalId: 
    roleDefinitionId: 
  }
}





