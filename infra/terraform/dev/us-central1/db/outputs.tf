output "sql-instances-public-ips" {
  value = {
    development_db = google_sql_database_instance.zksync_dev_01.ip_address[0].ip_address,
    external_node_development_db = google_sql_database_instance.zksync_en_dev_01.ip_address[0].ip_address
    prover_development_db = google_sql_database_instance.zksync_dev_prover_01.ip_address[0].ip_address
  }
}
