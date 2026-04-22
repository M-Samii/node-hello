variable "project_id" {
  description = "GCP project ID"
  type        = string
}
variable "region" { 
  description = "GCP region for resources"
  type        = string
}

variable "service_account" {
  description = "Custom service account for the GKE cluster"
  type        = string
}
variable "bucket_name" {
  description = "GCS bucket name for Terraform state"
  type        = string
}
variable "zone" {
  description = "GCP zone for resources like Jenkins VM"
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block for the master IPs in a private cluster"
  type        = string
}
# Legacy variables for backward compatibility



# General autoscaling settings
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
/*variable "max_autoscale_nodes" {
  description = "Maximum number of nodes for the autoscaling pool"
  type        = number

}*/

/*variable "autoscale_machine_type" {
  description = "Machine type for autoscale nodes (more powerful)"
  type        = string
}*/
variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}
# create  var.vpc_name var.subnet_name var.subnet_cidr var.pods_range_cidr var.services_range_cidr
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}
variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}
variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string

}
variable "pods_range_cidr" {
  description = "CIDR block for the pods range"
  type        = string
}
variable "services_range_cidr" {
  description = "CIDR block for the services range"
  type        = string

}

/*variable "database_machine_type" {
  description = "Machine type for database nodes"
  type        = string
  
}*/
variable "working_machine_type" {
  description = "Machine type for working nodes (cost-effective)"
  type        = string
}
