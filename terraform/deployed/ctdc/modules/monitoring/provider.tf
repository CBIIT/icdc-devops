terraform {
  required_providers {

    sumologic = {
      source = "sumologic/sumologic"
      #version = "" # set the Sumo Logic Terraform Provider version
    }

    newrelic = {
      source = "newrelic/newrelic"
    }

  }
  required_version = ">= 0.13"
}

provider "sumologic" {
  access_id   = var.sumologic_access_id
  access_key  = var.sumologic_access_key
  environment = "fed"
}

provider "newrelic" {
  account_id = var.newrelic_account_id
  api_key    = var.newrelic_api_key
  region     = "US"
}