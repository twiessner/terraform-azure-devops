
env                       = "dev"
workload                  = "sandbox-demo"
azure_devops_project_name = "sandbox-demo"

location = {
  name  = "westeurope"
  short = "westeu"
  mini  = "weu"
}

agent_pools = {
  ubuntu2024-dev = {
    sku = "Standard_D1_v2"
    instances = {
      min           = 1
      max           = 2
      idle_time_min = 45
    }
    spot_enabled = true
    virtual_network = {
      name                = "vnet-dev-001"
      subnet_name         = "snet-devops"
      resource_group_name = "rg-network-001"
    }
  }
}

repositories = {
  automation = {
    files = {
      hello-world-pipeline = {
        path    = ".azdo/azure-pipelines.yaml"
        content = <<CONTENT
trigger: none

pool:
  name: ubuntu2024-dev-sandbox

stages:
  - stage: Default
    jobs:
      - job: Hello_World
        steps:
          - script: echo "Hello World..."
CONTENT
      }
    }
  }
}

pipelines = {
  hello-world = {
    file_path       = ".azdo/azure-pipelines.yaml"
    repository_name = "automation"
    agent_pool_name = "ubuntu2024-dev"
  }
}