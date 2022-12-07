//==============================================================
// Bicep Module for Data Factory deployments for assesments
//AdrianJ / v1.0 / 2022-1
//==============================================================
param contactEmails array
param budgetAmount int
param candidateID string
param startDate string
param thresholdBudget int 
param resourceGroupName string 

var budgetName = 'consumption-budget-${candidateID}'

resource rgAssesmentBudget 'Microsoft.Consumption/budgets@2021-10-01' =  {
  name: budgetName
  properties: {
    amount: budgetAmount
    category: 'Cost'
    timeGrain: 'Monthly'
    timePeriod: {
      startDate: startDate
    }
    notifications: {
      NotificationForExceedBudget: {
        contactEmails: contactEmails
        enabled: true
        operator: 'GreaterThanOrEqualTo'
        threshold: thresholdBudget
      }
    }
    filter: {
      and: [
        {
          dimensions: {
            name: 'ResourceGroupName'
            operator: 'In'
            values: [
              resourceGroupName
            ]
          }
        }
      ]    
    }
  }
}
