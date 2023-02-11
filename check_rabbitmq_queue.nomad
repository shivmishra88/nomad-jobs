job "check-rabbitmq-queues" {
  datacenters = ["dc1"]

  type = "batch"

  periodic {
    // Launch every 2 minutes
    //cron = "*/2 * * * *"

    // Do not allow overlapping runs.
    prohibit_overlap = true
  }

  task "check-queues" {
    driver = "docker"

    config {
      image = "shivmishra/rabbitmq-queue-check"
      }
      env = {
        RABBITMQ_HOST = "rabbitmq.service.consul"
        VHOST = "%2F"
        QUEUE_THRESHOLD= "5"
        WEBHOOK_URL = "https://webhook.office.com/webhookb2/..../...."
      }
    }

}
