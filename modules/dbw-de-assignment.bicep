param candidateID string
param candidateAadObjectID string
param location string
param managedStorageAccountName string

var contributorRoleDefinitionObjectId = resourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
var databricksWorkspaceName = 'dbw-de-assesment-${candidateID}'
var managedResourceGroupName = 'dbw-de-assesment-${candidateID}-${uniqueString(candidateID, resourceGroup().id)}'
var sievoDataEngineeringEngineeringAadObjectId = '572ed27b-268d-49d2-9270-59090fc6e1bd'
//var storageAccountIdentityName = 'dbmanagedidentity-${candidateID}'

// Vnet configuration

resource databricksWorkspace 'Microsoft.Databricks/workspaces@2022-04-01-preview' = {
  name: databricksWorkspaceName
  location: location
  sku:{
    name: 'standard'
  }
  properties: {
    authorizations: [
      {
        principalId:sievoDataEngineeringEngineeringAadObjectId
        roleDefinitionId: contributorRoleDefinitionObjectId
      }
      {
        principalId: candidateAadObjectID
        roleDefinitionId: contributorRoleDefinitionObjectId
      }
    ]
    managedResourceGroupId: managedResourceGroup.id
    parameters: {
      enableNoPublicIp: {
        value: false /// what is the current configuration?
      }
      storageAccountName: {
        value: managedStorageAccountName
      }
      storageAccountSkuName: {
        value: 'Standard_GRS'
      }
    }
  }
}

resource managedResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  scope: subscription()
  name: managedResourceGroupName
}
