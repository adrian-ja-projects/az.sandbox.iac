//==============================================================
// Bicep Module for Data Factory deployments for assesments
//AdrianJ / v1.0 / 2022-1
//==============================================================
param dataFactoryName string
param location string

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
}
