variable "project_id" {
  type        = string
  description = "GCP project to create the Kubernetes cluster in"
}

variable "svc_account_key" {
  type        = string
  description = "Service account key in Base64 encoded format."

  validation {
      condition   = can(base64decode(var.svc_account_key))
      error_message = "The service account key is not in base64 encoded format."
  }
}

variable "region" {
  type        = string
  description = "GCP region to use with the provider."
}

variable "cluster_location" {
  type        = string
  description = "Location to create the GKE clsuter in."
}

variable "vpc_configured" {
  type        = bool
  description = "Specifies if the VPC has already been created or not."
  default     = false
}

variable "controlplane_configured" {
  type        = bool
  description = "Specifies if the K8s controlplane has already been created or not."
  default     = false
}

variable "use_default_nodepool" {
  type        = bool
  default     = false
  description = "Specifies if we should use the deafult node pool for the cluster."
}

variable "vpc_name" {
  type        = string
  description = "VPC to create the GKE cluster in."

  validation {
    condition     = length(var.vpc_name) > 5 && length(var.vpc_name) < 64
    error_message = "Length of the name of the vpc shoud be from 5 characters to 64 characters."
  }
}

variable "cluster_name" {
  type        = string
  description = "Name of the GKE cluster."

  validation {
    condition     = length(var.cluster_name) > 5 && length(var.cluster_name) < 64
    error_message = "Length of the name of the cluster shoud be from 5 characters to 64 characters."
  }
}

variable "kubernetes_version" {
  type        = string
  default     = "latest"
  description = "Kubernetes version to use for the GKE cluster."
}

variable "node_zones" {
  type        = list(string)
  description = "A list of zones in the location provided in which to launch the nodes."
  default     = []
}

variable "node_machine_type" {
  type        = string
  description = "GCP machine type to use for the Kubernetes cluster node"

  validation {
    condition     = contains(["n1-standard-8", "n1-standard-4", "n1-standard-2", "n1-standard-1"], var.node_machine_type)
    error_message = "Node machine type for the cluster must be from the predefined list."
  }
}

variable "node_image_type" {
  type        = string
  description = "Image to use for the Kubernetes node"

  validation {
    condition     = contains(["COS_CONTAINERD"], var.node_image_type)
    error_message = "Node image type to use for the Kubernetes node."
  }
}

variable "node_count" {
  type        = number
  default     = 1
  description = "Number of worker nodes in the Kubernetes cluster."

  validation {
    condition     = var.node_count > 0 && var.node_count < 100
    error_message = "Node count for the cluster must be between 0-100."
  }
}
