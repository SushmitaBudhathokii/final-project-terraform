#!/bin/bash
sudo yum update -y
sudo yum install -y postgresql-server postgresql-contrib
postgresql-setup initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Function to update postgresql.conf
update_listen_address() {
  echo "Updating listen_addresses in datapostgresql.conf..."

# Use sed to replace or add the listen_addresses line
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/data/postgresql.conf
}

# Function to update pg_hba.conf
update_hba_conf() {
  echo "Updating pg_hba.conf..."

  # Add a line to pg_hba.conf to trust connections from the specified network
  echo "host    postgres             postgres             10.1.0.0/16            trust" | sudo tee -a /var/lib/pgsql/data/pg_hba.conf
}

# Function to restart PostgreSQL
restart_postgresql() {
  echo "Restarting PostgreSQL service..."
  sudo systemctl stop postgresql
  sudo systemctl status postgresql # Optional: Check status after restart
  sudo systemctl start postgresql
}

# --- Main Script ---

# 1. Update listen_addresses in postgresql.conf
update_listen_address

# 2. Update pg_hba.conf
update_hba_conf

# 3. Restart PostgreSQL
restart_postgresql

echo "PostgreSQL configuration updated."