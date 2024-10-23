# Consumption Budget Resource Group

This example illustrates one resource group consumption budget. Multiple consumption budgets can be added under the consumption_budget_resource_groups key.

## Types

```hcl
config = object({
  consumption_budget_resource_groups = map(object({
    name                = optional(string)
    resource_group_id   = string
    amount              = number
    time_grain          = optional(string)
    time_period = object({
      start_date = string
      end_date   = optional(string)
    })

    notifications = map(object({
      operator       = string
      threshold      = number
      threshold_type = optional(string)
      contact_emails = optional(list(string))
      contact_groups = optional(list(string))
      contact_roles  = optional(list(string))
      enabled        = optional(bool)
    }))

    filter = optional(object({
      dimensions = optional(map(object({
        name     = string
        operator = string
        values   = list(string)
      })))
      tags = optional(map(object({
        name     = string
        operator = string
        values   = list(string)
      })))
    }))
  }))
})
```