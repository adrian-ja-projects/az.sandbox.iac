param candidateAadObjectId string
param resourceGroupName string

targetScope = 'subscription'

var readerRoleDefinitionId = 'acdd72a7-3385-48ef-bd42-f606fba81ae7'

resource roleAssignmentReaderCandidate 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, resourceGroupName, 'reader')
  properties: {
    principalId: candidateAadObjectId
    roleDefinitionId: readerRoleDefinitionId
  }
}
