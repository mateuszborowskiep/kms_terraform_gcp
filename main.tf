# Define the provider and required variables
provider "google" {
  project = "rosy-crawler-389806"
  region  = "europe-west1"
}

variable "key_ring_name" {
  description = "Name of the key ring"
  default     = "key-ring"
}

variable "crypto_key_name" {
  description = "Name of the crypto key"
  default     = "crypto-key"
}

# Enable the Cloud KMS API
resource "google_project_service" "cloud_kms" {
  service = "cloudkms.googleapis.com"
  project = "rosy-crawler-389806"
}

# Create a key ring
resource "google_kms_key_ring" "my_key_ring" {
  name     = var.key_ring_name
  location = "global"
}

# Create a crypto key within the key ring
resource "google_kms_crypto_key" "my_crypto_key" {
  name       = var.crypto_key_name
  key_ring   = google_kms_key_ring.my_key_ring.id
  purpose    = "ENCRYPT_DECRYPT"
  version_template {
    algorithm       = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = "SOFTWARE"
  }
}
