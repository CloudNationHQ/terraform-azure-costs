This example illustrates one management group consumption budget. Multiple consumption budgets can be added under the consumption_budget_management_groups key.

## Usage: consumption_budget_management_group

```hcl
module "costs" {
  source  = "cloudnationhq/costs/azure"
  version = "~> 1.0"

  config = {
    consumption_budget_management_groups = {
      cbmg1 = {
        name                = "cbmg1"
        management_group_id = "/providers/Microsoft.Management/managementGroups/Tenant Root Group"
        amount              = 100
        time_grain          = "Monthly"
        time_period = {
          start_date = "2023-01-01T00:00:00Z"
          end_date   = "2024-01-01T00:00:00Z"
        }

        filter = {
          dimensions = {
            dimension1 = {
              name     = "ResourceGroupName"
              operator = "In"
              values = [
                module.rg.groups.demo.name,
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
            contact_emails = ["email@demo-mag-email.nl"]
            enabled        = true
          }

          notification2 = {
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