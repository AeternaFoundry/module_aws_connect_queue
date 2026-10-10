variable "connect_queues" {
  description = <<EOT
Map of connect_queues, attributes below
Required:
    - hours_of_operation_id
    - instance_id
    - name
Optional:
    - description
    - max_contacts
    - quick_connect_ids
    - region
    - status
    - tags
    - tags_all
    - outbound_caller_config (block):
        - outbound_caller_id_name (optional)
        - outbound_caller_id_number_id (optional)
        - outbound_flow_id (optional)
EOT

  type = map(object({
    hours_of_operation_id = string
    instance_id           = string
    name                  = string
    description           = optional(string)
    max_contacts          = optional(number)
    quick_connect_ids     = optional(set(string))
    region                = optional(string)
    status                = optional(string)
    tags                  = optional(map(string))
    tags_all              = optional(map(string))
    outbound_caller_config = optional(object({
      outbound_caller_id_name      = optional(string)
      outbound_caller_id_number_id = optional(string)
      outbound_flow_id             = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.connect_queues : (
        v.max_contacts == null || (v.max_contacts >= 0)
      )
    ])
    error_message = "must be at least 0"
  }
  validation {
    condition = alltrue([
      for k, v in var.connect_queues : (
        v.outbound_caller_config == null || (v.outbound_caller_config.outbound_caller_id_name == null || (length(v.outbound_caller_config.outbound_caller_id_name) >= 1 && length(v.outbound_caller_config.outbound_caller_id_name) <= 255))
      )
    ])
    error_message = "must be between 1 and 255 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.connect_queues : (
        v.outbound_caller_config == null || (v.outbound_caller_config.outbound_flow_id == null || (length(v.outbound_caller_config.outbound_flow_id) >= 1 && length(v.outbound_caller_config.outbound_flow_id) <= 500))
      )
    ])
    error_message = "must be between 1 and 500 characters"
  }
  # Note: 4 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

