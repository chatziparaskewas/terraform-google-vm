/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {

  version = "~> 3.0"
}

resource "google_compute_reservation" "reservation" {
  project = var.project_id
  name    = "compute-instance-reservation-affinity"

  description                   = "compute-instance-reservation-affinity"
  specific_reservation_required = true
  zone                          = var.zone

  specific_reservation {
    count = var.num_instances
    instance_properties {
      machine_type = var.machine_type
    }
  }
}

module "instance_template" {
  source          = "../../../modules/instance_template"
  region          = var.region
  project_id      = var.project_id
  subnetwork      = var.subnetwork
  service_account = var.service_account

  machine_type = var.machine_type
  reservation_affinity = {
    type = "SPECIFIC_RESERVATION"
    specific_reservation = {
      key    = "compute.googleapis.com/reservation-name"
      values = ["compute-instance-reservation-affinity"]
    }
  }
}

module "compute_instance" {
  source            = "../../../modules/compute_instance"
  region            = var.region
  zone              = var.zone
  subnetwork        = var.subnetwork
  num_instances     = var.num_instances
  hostname          = "compute-instance-reservation-affinity"
  instance_template = module.instance_template.self_link
  access_config = [{
    nat_ip       = var.nat_ip
    network_tier = var.network_tier
  }, ]
}
