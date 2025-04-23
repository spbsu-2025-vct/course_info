data "vkcs_networking_network" "extnet" { # Получение данных о существующей внешней сети
  name = "internet"
}

resource "vkcs_networking_network" "k8s" { # Создание основной сети для Kubernetes
  name           = "k8s-net"
  admin_state_up = true # включает сеть сразу после создания.
}

resource "vkcs_networking_subnet" "k8s" { # Создание подсети 
  name            = "k8s-subnet"
  network_id      = vkcs_networking_network.k8s.id
  cidr            = "192.168.199.0/24"
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "vkcs_networking_router" "k8s" { # создание маршрутизатора
  name                = "k8s-router"
  admin_state_up      = true
  external_network_id = data.vkcs_networking_network.extnet.id
}

resource "vkcs_networking_router_interface" "k8s" { # Связывает подсеть с роутером, обеспечивая доступ в интернет через внешнюю сеть.
  router_id = vkcs_networking_router.k8s.id
  subnet_id = vkcs_networking_subnet.k8s.id
}