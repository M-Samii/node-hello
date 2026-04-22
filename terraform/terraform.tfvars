project_id = "project-3f56de35-b2ce-4cd3-886"
region     = "europe-north1"
zone       = "europe-north1-b"
service_account = "nawy-cluster@project-3f56de35-b2ce-4cd3-886.iam.gserviceaccount.com" 
bucket_name = "terraformstatefilenawy"
vpc_name   = "nawy-vpc"
subnet_name = "nawy-subnet"
master_ipv4_cidr_block = "10.0.100.0/28"
subnet_cidr = "10.0.0.0/24"
pods_range_cidr = "10.1.0.0/16"
services_range_cidr = "10.2.0.0/20"
cluster_name = "nawy-cluster"

# Legacy variables (kept for compatibility)


# Mixed machine type autoscaling configuration
enable_preemptible = true

# working nodes (always running) - Cost-effective smaller machines
working_node_count = 1            # Start with 4 small nodes

#database_machine_type = "e2-highmem-2"
# Autoscale nodes (scale from 0) - More powerful machines for peak load

#max_autoscale_nodes = 3              # Can scale up to 3 additional nodes (was 2)
#autoscale_machine_type = "e2-medium"  # Keep consistent machine type
working_machine_type = "e2-standard-4"
