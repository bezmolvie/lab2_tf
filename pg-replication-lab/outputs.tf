output "hosts" {
  value = [
    for h in yandex_mdb_postgresql_cluster.pg.host : {
      name = h.name
      fqdn = h.fqdn
      role = h.role
      zone = h.zone
    }
  ]
}
