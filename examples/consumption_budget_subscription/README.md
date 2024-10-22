This example illustrates one subscription consumption budget. Multiple consumption budgets can be added under the consumption_budget_subscriptions key.

## Usage: consumption_budget_subscription

```hcl
module "costs" {
  source  = "cloudnationhq/costs/azure"
  version = "~> 1.0"

  config = {
    consumption_budget_subscriptions = {
      cbs1 = {
        name       = "cbs1"
        amount     = 100
        time_grain = "Monthly"
        time_period = {
          start_date = "2024-10-01T00:00:00Z"
          end_date   = timestamp()
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