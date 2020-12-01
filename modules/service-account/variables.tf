#=======================================================
# Variables - Project
#=======================================================
variable "id-project" {
  type        = string
  description = "ID of project"
}

variable "name-prefix" {
  type        = string
  description = "Name suffix (e.g. client name) for named resources; forced into lowercase"
}

#=======================================================
# Variables - Service Account
#=======================================================
variable "id-account" {
  type        = string
  description = "ID for new service account"
}

variable "name-display" {
  type        = string
  description = "Displayed name of service account"
}

variable "roles-attached" {
  type        = map(string)
  description = "Map of roles to attach to service account"
}

variable "authorized-members" {
  type        = list(string)
  description = "List of authorized users/service accounts that can modify this new service account"
}
