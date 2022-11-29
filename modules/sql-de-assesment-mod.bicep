param administratorLogin string
@secure()
param administratorLoginPassword string
param location string
param sqlDBName string
param sqlServerName string

var sievoDataEngineeringEngineeringGroupName = '572ed27b-268d-49d2-9270-59090fc6e1bd'
var sievoDataEngineeringEngineeringAadObjectId = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'Group'
      azureADOnlyAuthentication: false
      login: sievoDataEngineeringEngineeringGroupName
      sid: sievoDataEngineeringEngineeringAadObjectId
      tenantId: subscription().tenantId
    }
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: sqlServer
  name: sqlDBName
  location: location
  sku: {
    capacity: 5
    name : 'Basic'
  }
   properties: {
    autoPauseDelay: 60
    zoneRedundant: false
    createMode: 'Default'
   }
}
