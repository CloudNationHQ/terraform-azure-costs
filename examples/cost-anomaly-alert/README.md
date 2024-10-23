# Cost Anomaly Alert

This example illustrates one cost anomaly alert. Multiple cost anomaly alerts can be added under the cost_anomaly_alerts key.

## Types

```hcl
config = object({
  cost_anomaly_alerts = map(object({
    key = object({
      name            = optional(string)
      display_name    = string
      subscription_id = string(optional)
      email_subject   = string
      email_addresses = list(string)
      message         = string(optional)
    })
  }))
})
```