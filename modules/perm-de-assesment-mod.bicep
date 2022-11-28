//param candidateID string
param candidateAadObjectId string
param dataFactoryName string
param databricksManagedIdentityName string
//param databricksWorkspaceName string
param keyVaultName string
param storageAccountName string

var sievoDataEngineeringEngineeringAadObjectId = '572ed27b-268d-49d2-9270-59090fc6e1bd'
// var azureDevopsPipelineAgentObjectId = 'tbd'
var storageBlobDataContributorRoleID = resourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe') //is this the correct one to storage account
//var managedResourceGroupName = 'dbw-de-assesment-${candidateID}-${uniqueString(candidateID, resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageAccountName
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource databricksManagedIdentity 'Microsoft.ManagedIdentity/identities@2022-01-31-preview' existing = {
  name: databricksManagedIdentityName
}

resource keyVaultAccessPolicies 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  parent: keyVault
  name: 'add'
  properties: {
    accessPolicies: [
      // {
      //   objectId: azureDevopsPipelineAgentObjectId
      //   permissions: {
      //     secrets: [
      //       'list'
      //       'get'
      //       'set'
      //     ]
      //   }
      //   tenantId: subscription().id
      // }
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

@description('Assigns the sievo group to Storage Blob Data Contributor Role for the adls in the resource group')
resource userRoleAssignmentADLSSievo 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storageAccount
  name: guid(storageAccount.id, sievoDataEngineeringEngineeringAadObjectId, 'Storage Blob Data Contributor')// should the storage blob contains spaces?
  properties: {
    principalId: sievoDataEngineeringEngineeringAadObjectId
    roleDefinitionId: storageBlobDataContributorRoleID
  }
  dependsOn: [
    storageAccount
  ]
}

@description('Assigns the candidate to Storage Blob Data Contributor Role for the adls in the resource group')
resource userRoleAssignmentADLSCandidate 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storageAccount
  name: guid(storageAccount.id, candidateAadObjectId, 'Storage Blob Data Contributor')// should the storage blob contains spaces?
  properties: {
    principalId: candidateAadObjectId
    roleDefinitionId: storageBlobDataContributorRoleID
  }
  dependsOn: [
    storageAccount
  ]
}

resource adfStorageDataBlobContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().name, dataFactoryName, 'Storage Blob Data Contributor')
  scope: storageAccount
  properties: {
    principalId: dataFactory.identity.principalId
    roleDefinitionId: storageBlobDataContributorRoleID
    principalType: 'ServicePrincipal'
  }
  dependsOn: [
    storageAccount
    dataFactory
  ]
}

resource databricksServicePrincipalStorageDataBlobContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().name, databricksManagedIdentityName, 'Storage Blob Data Contributor')
  scope: storageAccount
  properties: {
    principalId: databricksManagedIdentity.id
    roleDefinitionId: storageBlobDataContributorRoleID
  }
  dependsOn: [
    storageAccount
  ]
}
