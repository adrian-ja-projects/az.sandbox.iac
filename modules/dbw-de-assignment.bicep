param candidateID string
param location string
param managedStorageAccountName string

var databricksWorkspaceName = 'dbw-de-assesment-${candidateID}'
var managedResourceGroupName = 'dbw-de-assesment-${candidateID}-${uniqueString(candidateID, resourceGroup().id)}'

resource databricksWorkspace 'Microsoft.Databricks/workspaces@2022-04-01-preview' = {
  name: databricksWorkspaceName
  location: location
  sku:{
    name: 'standard'
  }
  properties: {
    managedResourceGroupId: managedResourceGroup.id
    parameters: {
      enableNoPublicIp: {
        value: false
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
