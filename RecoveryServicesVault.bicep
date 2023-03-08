@description('Recovery Vault Purpose')
@allowed([
  'backup'
  'siterecovery'
])
param vaultPurpose string

@description('Recovery Vault Storage Type')
@allowed([
  'LocallyRedundant'
  'GeoRedundant'
])
param vaultStorageType string = 'GeoRedundant'

@description('Enable Cross-Regional Restore (Only if GeoRedundant Storage Type)')
@allowed([
  true
  false
])
param enableCRR bool = true

@description('Location for all resources.')
param location string = resourceGroup().location



var vaultName = 'rsv-${vaultPurpose}-${location}'
var skuName = 'RS0'
var skuTier = 'Standard'

resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@2022-02-01' = {
  name: vaultName
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {}
}

resource vaultName_vaultstorageconfig 'Microsoft.RecoveryServices/vaults/backupstorageconfig@2022-02-01' = {
  parent: recoveryServicesVault
  name: 'vaultstorageconfig'
  properties: {
    storageModelType: vaultStorageType
    crossRegionRestoreFlag: enableCRR
  }
}
