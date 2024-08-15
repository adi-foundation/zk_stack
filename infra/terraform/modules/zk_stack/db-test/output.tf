output "db_private_ip" {
  value = google_sql_database_instance.general.private_ip_address
}

output "prover_db_private_ip" {
  value = google_sql_database_instance.prover.private_ip_address
}
