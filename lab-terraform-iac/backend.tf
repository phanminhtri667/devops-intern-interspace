terraform {
  backend "gcs" {
    bucket  = "terraform-tfstate-devops-rke2"
    prefix  = "rke2-lab"
  }
}
