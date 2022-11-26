param azureADUserName string
param azureADObjectID string
param administratorLogin string
@secure()
param administratorLoginPassword string
param location string
param sqlDBName string
param sqlServerName string

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    administrators: {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: true
      login: azureADUserName
      sid: azureADObjectID
      tenantId: subscription().tenantId

    }
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: sqlServer
  name: sqlDBName
  location: location
  sku: {
    capacity: 5
    name : 'standard'
  }
}
