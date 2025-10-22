terraform {
  required_providers {
    google  = { source = "hashicorp/google",  version = "~> 5.0" }
    aws     = { source = "hashicorp/aws",     version = "~> 5.0" }
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}

# -------------------------------------------------------------------
#  GCP PROVIDER (kích hoạt khi cloud_provider == "gcp")
# -------------------------------------------------------------------
provider "google" {
  project = var.project_id
  region  = var.region
  alias   = "gcp"
  # Terraform không có if provider, nhưng bạn có thể ép AWS/Azure không chạy
  # bằng cách dựa vào điều kiện trong module (chỉ module GCP gọi provider này)
}

# -------------------------------------------------------------------
#  AWS PROVIDER - Dùng null credentials để vô hiệu hoá hoàn toàn khi không chọn AWS
# -------------------------------------------------------------------
provider "aws" {
  region  = var.region
  profile = var.aws_profile
  alias   = "aws"

  # Vô hiệu hoá provider AWS nếu không dùng
  access_key = var.cloud_provider == "aws" ? "" : "null"
  secret_key = var.cloud_provider == "aws" ? "" : "null"
  skip_credentials_validation = var.cloud_provider != "aws"
  skip_metadata_api_check     = var.cloud_provider != "aws"
  skip_requesting_account_id  = var.cloud_provider != "aws"
}

# -------------------------------------------------------------------
#  AZURE PROVIDER - Không đăng ký nếu không chọn Azure
# -------------------------------------------------------------------
provider "azurerm" {
  features {}
  alias = "azure"

  skip_provider_registration = var.cloud_provider != "azure"
}
