This example illustrates one resource group consumption budget. Multiple consumption budgets can be added under the consumption_budget_resource_groups key.

## Usage: consumption_budget_resource_group

```hcl
module "costs" {
  source  = "cloudnationhq/costs/azure"
  version = "~> 1.0"

  config = {
    consumption_budget_resource_groups = {
      cbrg1 = {
        name              = "cbrg1"
        resource_group_id = module.rg.groups.demo.id
        amount            = 1000
        time_grain        = "Monthly"
        time_period = {
          start_date = "2024-10-01T00:00:00Z"
          end_date   = timestamp()
        }

        filter = {
          dimensions = {
            dimension1 = {
              name     = "ResourceId"
              operator = "In"
              values = [
                module.mag.groups.demo.id,
              ]
            }
          }

          tags = {
            tag1 = {
              name     = "foo"
              operator = "In"
              values = [
                "bar",
                "baz",
              ]
            }
          }
        }

        notifications = {
          notification1 = {
            operator       = "EqualTo"
            threshold      = 90.0
            threshold_type = "Forecasted"
            contact_groups = [module.mag.groups.demo.id]
            contact_roles  = ["Owner"]
            enabled        = true
          }

          notification2 = {
            enabled        = false
            operator       = "GreaterThan"
            threshold      = 100.0
            threshold_type = "Forecasted"
            contact_emails = ["email@demo-mag-email.nl"]
          }
        }
      }
    }
  }
}
```