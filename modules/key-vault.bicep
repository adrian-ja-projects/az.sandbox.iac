@minLength(3)
@maxLength(15)
param location string
param keyVaultName string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location : location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableSoftDelete: true
    accessPolicies: [
      
    ]
  }
}
