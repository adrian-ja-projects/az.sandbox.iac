param candidateAadObjectId string
param dataFactoryName string
param keyVaultName string
param storageAccountName string
//param resourceGroupName string

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
    ]
  }
}

@description('Assigns the sievo group to Storage Blob Data Contributor Role for the adls in the resource group')
resource userRoleAssignmentADLSSievo 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storageAccount
  name: guid(storageAccount.id, sievoDataEngineeringEngineeringAadObjectId, 'Storage Blob Data Contributor')
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
  name: guid(storageAccount.id, candidateAadObjectId, 'Storage Blob Data Contributor')
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

// resource roleAssignmentReaderCandidate 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid(subscription().id, resourceGroupName, 'reader')
//   properties: {
//     principalId: candidateAadObjectId
//     roleDefinitionId: readerRoleDefinitionId
//   }
// }
