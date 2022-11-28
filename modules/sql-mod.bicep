param administratorLogin string
@secure()
param administratorLoginPassword string
param location string
param sqlDBName string
param sqlServerName string

var sievoDataEngineeringEngineeringGroupName = 'tbd'
var sievoDataEngineeringEngineeringAadObjectId = 'tbd'

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'Group'
      azureADOnlyAuthentication: true
      login: sievoDataEngineeringEngineeringGroupName
      sid: sievoDataEngineeringEngineeringAadObjectId
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
    name : 'Basic'
  }
   properties: {
    maxSizeBytes: 10737418240
    zoneRedundant: false
   }
}
