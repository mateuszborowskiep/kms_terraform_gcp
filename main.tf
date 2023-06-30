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

## Bucket for realize encryption
resource "google_storage_bucket" "encrypted-store" {
  name     = "encrypted-store-bucket"
  location = "EU"
  encryption {
    default_kms_key_name = var.crypto_key_name
  }
  depends_on = [
    google_kms_crypto_key.my_crypto_key
  ]
}

## ACL for bucket
resource "google_storage_default_object_acl" "encrypted-store-default-acl" {
  bucket = google_storage_bucket.encrypted-store.name
  role_entity = [
    "OWNER:admin@cloudsecurity.team",
  ]
}
