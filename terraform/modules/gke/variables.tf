variable "cluster_name" { type = string }
variable "region" { type = string }
variable "zone" { 
  type = string 
  description = "Specific zone for zonal cluster"
}
variable "project_id" { type = string }
variable "vpc_network" {
  description = "VPC network ID"
  type        = string
}

variable "vpc_subnetwork" {
  description = "Subnetwork ID"
  type        = string
}
variable "master_ipv4_cidr_block" {
  description = "CIDR block for the master IPs in a private cluster"
  type        = string
 }

 variable "pods_secondary_range_name" {
  description = "Secondary range name for pods"
  type        = string
   
 }

 variable "services_secondary_range_name" {
  description = "Secondary range name for services"
  type        = string
}
# Legacy variables for backward compatibility




# General settings
variable "enable_preemptible" {
  description = "Enable preemptible nodes for cost savings"
  type        = bool
  default     = true
}

# working node pool configuration (always running, cost-effective)
variable "working_node_count" {
  description = "Number of working nodes that are always running"
  type        = number
  default     = 1
}


# Autoscaling node pool configuration (scales from 0, more powerful)
/*variable "max_autoscale_nodes"{
  description = "Maximum number of nodes for the autoscaling pool"
  type        = number
  default     = 0
}*/


variable "service_account" {
  description = "Custom service account for the node pool"
  type        = string
}
/*variable "database_machine_type" {
  description = "Machine type for database nodes"
  type        = string
  default     = "e2-medium"
}*/

variable "working_machine_type" {
  description = "Machine type for working nodes (cost-effective)"
  type        = string
}

/*variable "autoscale_machine_type"{
  description = "Machine type for autoscaling nodes"
  type        = string
  default     = ""
}*/
