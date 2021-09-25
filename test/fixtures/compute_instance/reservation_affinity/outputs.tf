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

output "instances_self_links" {
  description = "List of instance self-links"
  value       = module.instance_reservation_affinity.instances_self_links
}

output "project_id" {
  description = "The GCP project to use for integration tests"
  value       = var.project_id
}

output "num_instances" {
  description = "Number of instances created"
  value       = module.instance_reservation_affinity.num_instances
}
