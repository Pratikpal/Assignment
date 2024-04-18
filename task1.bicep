@description('Location of the desired resource')
param location string = resourceGroup().location

@description('Name of the Virtual Network')
param virtualNetworkName string = 'vnet46340639'

@description('Name of virtual Machine')
param virtualMachineName string = 'vm46340639'

@description('User name of virtual machine')
param adminUsername string = 'adminUsername'

@secure()
@description('Virtual machine password')
param adminPassword string = 'Pratik#1234567890'
param appServicePlanSku object
param vmName string = 'myVM'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${virtualNetworkName}-subnet'
  parent: virtualNetwork
  properties: {
    addressPrefix: '10.0.1.0/24'
  }
}


resource nic 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          subnet: {
            id: subnet.id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: virtualMachineName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    osProfile: {
      computerName: 'computerName'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType:'StandardSSD_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
  }
}

output adminUsername string = adminUsername
output subnetid string = nic.id
