data "azurerm_subscription" "current" {}

# azurerm_consumption_budget_management_group
resource "azurerm_consumption_budget_management_group" "budget" {
  for_each = {
    for key, cbmg in lookup(var.config, "consumption_budget_management_groups", {}) : key => cbmg
  }

  name                = try(each.value.name, "cbmg-${each.key}")
  management_group_id = each.value.management_group_id
  amount              = each.value.amount
  time_grain          = try(each.value.time_grain, "Monthly")

  dynamic "time_period" {
    for_each = lookup(each.value, "time_period", null) != null ? [each.value.time_period] : []
    content {
      start_date = time_period.value.start_date
      end_date   = try(time_period.value.end_date, null)
    }
  }

  dynamic "notification" {
    for_each = {
      for key, notification in lookup(each.value, "notifications", {}) : key => notification
    }
    content {
      operator       = notification.value.operator
      threshold      = notification.value.threshold
      threshold_type = try(notification.value.threshold_type, "Actual")
      contact_emails = notification.value.contact_emails
      enabled        = try(notification.value.enabled, true)
    }
  }

  dynamic "filter" {
    for_each = lookup(each.value, "filter", null) != null ? [each.value.filter] : []

    content {
      dynamic "dimension" {
        for_each = {
          for key, dimension in lookup(filter.value, "dimensions", {}) : key => dimension
        }
        content {
          name     = dimension.value.name
          operator = try(dimension.value.operator, "In")
          values   = dimension.value.values
        }
      }
      dynamic "tag" {
        for_each = {
          for key, tag in lookup(filter.value, "tags", {}) : key => tag
        }
        content {
          name     = tag.value.name
          operator = try(tag.value.operator, "In")
          values   = tag.value.values
        }
      }
    }
  }
}

# azurerm_consumption_budget_subscription
resource "azurerm_consumption_budget_subscription" "budget" {
  for_each = {
    for key, cbs in lookup(var.config, "consumption_budget_subscriptions", {}) : key => cbs
  }

  name            = try(each.value.name, "cbs-${each.key}")
  subscription_id = data.azurerm_subscription.current.id
  amount          = each.value.amount
  time_grain      = try(each.value.time_grain, "Monthly")

  dynamic "time_period" {
    for_each = lookup(each.value, "time_period", null) != null ? [each.value.time_period] : []
    content {
      start_date = time_period.value.start_date
      end_date   = try(time_period.value.end_date, null)
    }
  }

  dynamic "notification" {
    for_each = {
      for key, notification in lookup(each.value, "notifications", {}) : key => notification
    }
    content {
      operator       = notification.value.operator
      threshold      = notification.value.threshold
      threshold_type = try(notification.value.threshold_type, "Actual")
      contact_emails = try(notification.value.contact_emails, [])
      contact_groups = try(notification.value.contact_groups, [])
      contact_roles  = try(notification.value.contact_roles, [])
      enabled        = try(notification.value.enabled, true)
    }
  }

  dynamic "filter" {
    for_each = lookup(each.value, "filter", null) != null ? [each.value.filter] : []

    content {
      dynamic "dimension" {
        for_each = {
          for key, dimension in lookup(filter.value, "dimensions", {}) : key => dimension
        }
        content {
          name     = dimension.value.name
          operator = try(dimension.value.operator, "In")
          values   = dimension.value.values
        }
      }
      dynamic "tag" {
        for_each = {
          for key, tag in lookup(filter.value, "tags", {}) : key => tag
        }
        content {
          name     = tag.value.name
          operator = try(tag.value.operator, "In")
          values   = tag.value.values
        }
      }
    }
  }
}

# azurerm_consumption_budget_resource_group
resource "azurerm_consumption_budget_resource_group" "budget" {
  for_each = {
    for key, cbrg in lookup(var.config, "consumption_budget_resource_groups", {}) : key => cbrg
  }

  name              = try(each.value.name, "cbrg-${each.key}")
  resource_group_id = each.value.resource_group_id
  amount            = each.value.amount
  time_grain        = try(each.value.time_grain, "Monthly")

  dynamic "time_period" {
    for_each = lookup(each.value, "time_period", null) != null ? [each.value.time_period] : []
    content {
      start_date = time_period.value.start_date
      end_date   = try(time_period.value.end_date, null)
    }
  }

  dynamic "notification" {
    for_each = {
      for key, notification in lookup(each.value, "notifications", {}) : key => notification
    }
    content {
      operator       = notification.value.operator
      threshold      = notification.value.threshold
      threshold_type = try(notification.value.threshold_type, "Actual")
      contact_emails = try(notification.value.contact_emails, [])
      contact_groups = try(notification.value.contact_groups, [])
      contact_roles  = try(notification.value.contact_roles, [])
      enabled        = try(notification.value.enabled, true)
    }
  }

  dynamic "filter" {
    for_each = lookup(each.value, "filter", null) != null ? [each.value.filter] : []

    content {
      dynamic "dimension" {
        for_each = {
          for key, dimension in lookup(filter.value, "dimensions", {}) : key => dimension
        }
        content {
          name     = dimension.value.name
          operator = try(dimension.value.operator, "In")
          values   = dimension.value.values
        }
      }
      dynamic "tag" {
        for_each = {
          for key, tag in lookup(filter.value, "tags", {}) : key => tag
        }
        content {
          name     = tag.value.name
          operator = try(tag.value.operator, "In")
          values   = tag.value.values
        }
      }
    }
  }
}

# azurerm_cost_anomaly_alert
resource "azurerm_cost_anomaly_alert" "caa" {
  for_each = {
    for key, caa in lookup(var.config, "cost_anomaly_alerts", {}) : key => caa
  }

  name            = try(each.value.name, "caa-${each.key}")
  display_name    = each.value.display_name
  subscription_id = try(each.value.subscription_id, data.azurerm_subscription.current.id)
  email_addresses = each.value.email_addresses
  email_subject   = each.value.email_subject
  message         = try(each.value.message, "Anomaly detected in your Azure subscription")
}