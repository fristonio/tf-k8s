resource "google_container_cluster" "k8s_cluster" {
  name               = var.cluster_name
  location           = var.cluster_location

  # Create a node pool with one node and immediately delete it so that we can
  # use our own managed node pool.
  initial_node_count = 1
  remove_default_node_pool = true

  network            = google_compute_network.k8s_cluster_vpc.self_link
  subnetwork         = var.cluster_location

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }

  timeouts {
    create = "30m"
    update = "40m"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_container_node_pool" "k8s_cluster" {
  provider = google-beta

  depends_on = [ 
    google_compute_network.k8s_cluster_vpc,
    google_compute_subnetwork.k8s_cluster_subnets
  ]

  name               = "${var.cluster_name}-np"
  location           = var.cluster_location
  cluster            = google_container_cluster.k8s_cluster.name

  node_locations = toset(var.node_zones)

  node_count = tonumber(var.node_count)

  node_config {
    machine_type = var.node_machine_type
    image_type   = var.node_image_type

    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

    labels       = {
      node-pool = "default"
    }

    tags = ["iso-test-management-cluster"]

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  timeouts {
    create = "30m"
    update = "40m"
  }

  lifecycle {
    create_before_destroy = true
  }
}