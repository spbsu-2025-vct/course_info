data "vkcs_compute_flavor" "k8s-master-flavor" { # Получение информации о существующих ресурсах
    name = "STD3-4-8" # спецификация виртуальной машины (3 vCPU, 4 ГБ RAM, 8 ГБ диска)
}

data "vkcs_compute_flavor" "k8s-node-group-flavor" { # Получение информации о существующих ресурсах
 name = "STD2-2-4"
}

data "vkcs_kubernetes_clustertemplate" "k8s-template" { # Получает ID шаблона Kubernetes-кластера для указанной версии
    version = "1.31"
}

resource "vkcs_kubernetes_cluster" "k8s-cluster" {

  depends_on = [
    vkcs_networking_router_interface.k8s,
  ]

  name                = "k8s-cluster-tf"
  cluster_template_id = data.vkcs_kubernetes_clustertemplate.k8s-template.id
  master_flavor       = data.vkcs_compute_flavor.k8s-master-flavor.id
  master_count        = 1
  network_id          = vkcs_networking_network.k8s.id
  subnet_id           = vkcs_networking_subnet.k8s.id
  availability_zone   = "GZ1"

  floating_ip_enabled = true

  labels = {
    docker_registry_enabled = true
  }

}

resource "vkcs_kubernetes_node_group" "k8s-node-group" {
  name = "k8s-node-group"
  cluster_id = vkcs_kubernetes_cluster.k8s-cluster.id
  flavor_id = data.vkcs_compute_flavor.k8s-node-group-flavor.id

  node_count = 2
  autoscaling_enabled = false
  min_nodes = 1
  max_nodes = 3

  labels {
        key = "env"
        value = "test"
    }

  labels {
        key = "disktype"
        value = "ssd"
    }

  taints {
        key = "taintkey1"
        value = "taintvalue1"
        effect = "PreferNoSchedule"
    }

  taints {
        key = "taintkey2"
        value = "taintvalue2"
        effect = "PreferNoSchedule"
    }
}
