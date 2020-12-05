#=======================================================
# Variables - Project
#=======================================================
variable "location" {
  type        = string
  description = "GCP deployment location"
}

variable "id-project" {
  type        = string
  description = "ID of project"
}

variable "name-prefix" {
  type        = string
  description = "Name suffix (e.g. client name) for named resources; forced into lowercase"
}

#=======================================================
# Variables - VPC-Native Cluster Networking
#=======================================================
variable "name-vpc-cluster" {
  description = "Name of VPC"
}

variable "name-subnet-cluster" {
  description = "Name of subnet"
}

#=======================================================
# Variables - GKE                                  
#=======================================================
variable "k8s-username" {
  description = "GKE cluster admin username"
}

variable "k8s-password" {
  description = "GKE cluster admin password"
}

variable "config-gke-cluster" {
  type        = map(string)
  description = "Map of GKE cluster configuration"
}

variable "config-gke-nodepools" {
  type        = map(map(string))
  description = "Map of GKE node pools configurations"
}
