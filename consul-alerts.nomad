job "consul-alert" {
  datacenters = ["dc1"]

  update {
    stagger = "30s"
    max_parallel = 1
   }

  group "cache" {
    count = 1

     constraint {
      operator  = "distinct_hosts"
      value     = "true"
    }
   restart {
      attempts = 1
      interval = "25s"
      delay = "25s"

      mode = "delay"
    }

    ephemeral_disk {
      size = 300
    }

    task "server" {
      driver = "docker"



    config {
     image = "shivmishra/consul-alerts:teams"
     args = ["start", "--watch-events", "--watch-checks", "--consul-addr=${attr.unique.network.ip-address}:8500", "--log-level=debug"]
        port_map {
          db = 9000
      }
     }
      resources {
        cpu    =  1000
        memory =  1000
        network {
        mbits = 5
          port "db" {}

        }
      }

      service {
        name = "consul-alert"
        tags =  ["urlprefix-consul-alert.service.consul/"]
        port = "db"
        check {
          type     = "tcp"
          interval = "60s"
          timeout  = "2s"

             }
            }
      }

   }
}
