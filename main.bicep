param location string
param resourceGroupName string
param environmentType string

targetScope = 'subscription'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
  tags : {
    environmentType : environmentType
  }
}
