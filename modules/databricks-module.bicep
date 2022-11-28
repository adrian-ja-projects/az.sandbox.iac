param candidateID string
param databricksWorkspaceName string
param location string

var managedResourceGroupName = 'dbw-de-assesment-${candidateID}-${uniqueString(candidateID, resourceGroup().id)}'// should be assign an id to candidates

// Vnet configuration

resource databricksWorkspace 'Microsoft.Databricks/workspaces@2022-04-01-preview' = {
  name: databricksWorkspaceName
  location: location
  sku:{
    name: 'standard'
  }
  properties: {
    managedResourceGroupId: subscriptionResourceId('Microsoft.Resources/resourceGroups', managedResourceGroupName)
    ///Should this be created before or after
    parameters: {
      enableNoPublicIp: {
        value: false /// what is the current configuration?
      }
    }
  }
}
