#=======================================================
# Enable CRM API                                                                                                                       #=======================================================
resource "google_project_service" "gcp_resource_manager_api" {
  project = var.id-project
  service = "cloudresourcemanager.googleapis.com"
}

#=======================================================
# Service Account
#=======================================================
resource "google_service_account" "srv-acct" {
  account_id   = var.id-account
  display_name = var.name-display

  lifecycle {
    create_before_destroy = false
  }
}

#=======================================================
# Service Account - IAM
# > What roles are on the service account
#=======================================================
resource "google_project_iam_member" "srv-acct-iam" {
  for_each = var.roles-attached
  project  = var.id-project
  role     = each.value
  member   = "serviceAccount:${google_service_account.srv-acct.email}"
}

#=======================================================
# Service Account Binding - IAM
# > Who can administrate this service account
#=======================================================
resource "google_service_account_iam_binding" "srv-acct-admin" {
  service_account_id = google_service_account.srv-acct.name
  role               = "roles/iam.serviceAccountUser"

  members = var.authorized-members
}
