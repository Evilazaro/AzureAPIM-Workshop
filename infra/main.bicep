/*
  Azure API Management Infrastructure Deployment
  
  This template deploys the following resources at subscription level:
  - Resource group for containing all solution resources
  - API Management service via the apiManagement.bicep module
  
  Author: Your Organization
  Last Updated: May 9, 2025
*/

// Set deployment scope to subscription level
targetScope = 'subscription'

@description('Name of the overall solution used for resource naming convention')
@minLength(3)
@maxLength(24)
param solutionName string

@description('Primary Azure region for all resources')
@minLength(1)
param location string

// Resource group to contain all solution resources
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${solutionName}-rg'
  location: location
  tags: {
    Solution: solutionName
    Environment: 'Production'
    DeployedBy: 'Bicep'
  }
}

// Deploy API Management service using the module
module apim 'azureAPIManagement/apiManagement.bicep' = {
  scope: resourceGroup
  name: 'apiManagementDeployment'
  params: {
    solutionName: solutionName
    location: location
  }
}

// Output the resource group name for reference
@description('The name of the resource group containing all deployed resources')
output AZURE_RESOURCE_GROUP_NAME string = resourceGroup.name

// Output API Management deployment name
@description('The name of the API Management deployment')
output AZURE_APIM_NAME string = apim.outputs.AZURE_APIM_NAME
