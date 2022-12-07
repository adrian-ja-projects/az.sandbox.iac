param administratorLogin string
@secure()
param administratorLoginPassword string
param location string
param sqlDBName string
param sqlServerName string

var sievoDataEngineeringEngineeringGroupName = 'sievoSandboxDataEngineering'
var sievoDataEngineeringEngineeringAadObjectId = '09a0140e-e112-4f07-95b0-1192427a6ea9'

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

resource sqlServerFirewallRuleAllowAll 'Microsoft.Sql/servers/firewallRules@2022-05-01-preview' = {
  name: 'sqlServerFirewallAllowAll'
  parent: sqlServer
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
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
