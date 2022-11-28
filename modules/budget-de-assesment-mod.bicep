param contactEmails array
param budgetAmount int
param candidateID string
param startDate string
param thresholdBudget int // how to get percentage?
param resourceGroupName string // how to use the correct 

var budgetName = 'consumption-budget-${candidateID}'

//warning budget? 25eur
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
      dimensions: {
        name: resourceGroupName
        operator: 'In'
        values: [
          resourceGroupName
        ]
      }
    }
  }
}
