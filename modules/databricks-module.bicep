param databricksWorkspaceName string
param location string

resource databricksWorkspace 'Microsoft.Databricks/workspaces@2022-04-01-preview' = {
  name: databricksWorkspaceName
  location: location
  sku:{
    name: 'standard'
  }
  properties: {
    managedResourceGroupId: // do I need to create a managed resource group for dbw?
  }
}
