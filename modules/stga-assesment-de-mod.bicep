param candidateID string
@minLength(3)
@maxLength(15)
param storageAccountName string
param location string

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name : storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    isHnsEnabled: true
  }

  resource blobService 'blobServices' = {
    name: 'default'

    resource containers 'containers' = {
      name: '${candidateID}-stgcontainer'
      properties: {
      }
    }
  }
}


