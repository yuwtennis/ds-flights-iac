variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "network" {
  type = object({
    id        = string
    self_link = string
  })
}

variable "subnetwork" {
  type = object({
    id        = string
    self_link = string
  })
}

variable "psc_static_ipv4_addr" {
  type = string
}