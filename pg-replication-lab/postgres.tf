resource "yandex_mdb_postgresql_cluster" "pg" {
  name        = "pg-replication-lab"
  environment = "PRODUCTION"
  network_id  = yandex_vpc_network.lab.id

  config {
    version = "16"
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 10
    }
    postgresql_config = {
      synchronous_commit = "SYNCHRONOUS_COMMIT_ON"
    }
  }

   host {
   name             = "host-a"
    zone             = "ru-central1-a"
    subnet_id        = yandex_vpc_subnet.a.id
    assign_public_ip = true
    replication_source_name = "host-b"
   }
  host {
    name             = "host-b"
    zone             = "ru-central1-b"
    subnet_id        = yandex_vpc_subnet.b.id
    assign_public_ip = true
  }
  host {
    name             = "host-d"
    zone             = "ru-central1-d"
    subnet_id        = yandex_vpc_subnet.d.id
    assign_public_ip = true
  }
}

resource "yandex_mdb_postgresql_user" "student" {
  cluster_id = yandex_mdb_postgresql_cluster.pg.id
  name       = "student"
  password   = var.db_password
}

resource "yandex_mdb_postgresql_database" "labdb" {
  cluster_id = yandex_mdb_postgresql_cluster.pg.id
  name       = "labdb"
  owner      = yandex_mdb_postgresql_user.student.name
}
