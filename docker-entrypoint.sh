#!/bin/bash

# Reference --> https://medium.com/@beld_pro/quick-tip-creating-a-postgresql-container-with-default-user-and-password-8bb2adb82342

# Immediately exits if any error occurs during the script
# execution. If not set, an error could occur and the
# script would continue its execution.
set -o errexit


# Creating an array that defines the environment variables
# that must be set. This can be consumed later via arrray
# variable expansion ${REQUIRED_ENV_VARS[@]}.
readonly REQUIRED_ENV_VARS=(
  "FUSIONPBX_USER"
  "FUSIONPBX_PASSWORD"
  "FUSIONPBX_DB"
  "FREESWITCH_DB")


# Main execution:
# - verifies if all environment variables are set
# - runs the SQL code to create user and database
main() {
  check_env_vars_set
  init_user_and_db
  init_tables_and_roles
  disable_pgadmin_login
}


# Checks if all of the required environment
# variables are set. If one of them isn't,
# echoes a text explaining which one isn't
# and the name of the ones that need to be
check_env_vars_set() {
  for required_env_var in ${REQUIRED_ENV_VARS[@]}; do
    if [[ -z "${!required_env_var}" ]]; then
      echo "Error:
    Environment variable '$required_env_var' not set.
    Make sure you have the following environment variables set:
      ${REQUIRED_ENV_VARS[@]}
Aborting."
      exit 1
    fi
  done
}


# Performs the initialization in the already-started PostgreSQL
# using the preconfigured POSTGRES_USER user.
init_user_and_db() {
  psql -v ON_ERROR_STOP=1 --username postgres <<-EOSQL
     CREATE DATABASE $FUSIONPBX_DB;
	 CREATE DATABASE $FREESWITCH_DB;
	 CREATE ROLE $FUSIONPBX_USER WITH SUPERUSER LOGIN PASSWORD '$FUSIONPBX_PASSWORD';
	 CREATE ROLE $FREESWITCH_DB WITH SUPERUSER LOGIN PASSWORD '$FUSIONPBX_PASSWORD';
	 GRANT ALL PRIVILEGES ON DATABASE $FUSIONPBX_DB to $FUSIONPBX_USER;
	 GRANT ALL PRIVILEGES ON DATABASE $FREESWITCH_DB to $FUSIONPBX_USER;
	 GRANT ALL PRIVILEGES ON DATABASE $FREESWITCH_DB to $FREESWITCH_DB;
EOSQL
}

init_tables_and_roles() {
  psql -v ON_ERROR_STOP=1 --dbname $FUSIONPBX_DB --username $FUSIONPBX_USER --password $FUSIONPBX_PASSWORD <<-EOSQL
	CREATE TABLE IF NOT EXISTS "v_domains" (domain_uuid VARCHAR);
	CREATE TABLE IF NOT EXISTS "v_software" (domain_uuid VARCHAR);
	CREATE TABLE IF NOT EXISTS "v_default_settings" (domain_uuid VARCHAR, default_setting_order VARCHAR);
	CREATE TABLE IF NOT EXISTS "v_settings" (domain_uuid VARCHAR);
	CREATE TABLE IF NOT EXISTS "fusionpbx.v_domains" (domain_uuid VARCHAR);
	CREATE TABLE IF NOT EXISTS "fusionpbx.v_fax_logs" (fax_log_uuid VARCHAR);
	CREATE TABLE IF NOT EXISTS "fusionpbx.v_xml_cdr" (xml_cdr_uuid VARCHAR);
	CREATE TABLE IF NOT EXISTS "fusionpbx.v_conference_sessions" (conference_session_uuid VARCHAR);
	CREATE TABLE IF NOT EXISTS "fusionpbx.v_conference_session_details" (conference_session_detail_uuid VARCHAR);
	INSERT INTO "v_domains" (domain_uuid) VALUES (pegacorn-fusionpbx.site-a) ON CONFLICT DO NOTHING;
EOSQL
}

# Replace all instances of pegacorn with the value in the environment variable $SYNAPSE_DB 
# in the /var/lib/postgresql/data/pg_hba.conf file
disable_pgadmin_login() {
		rm -f /var/lib/postgresql/data/pg_hba.conf
		cp -f /var/lib/postgresql/config/pg_hba.conf /var/lib/postgresql/data/pg_hba.conf
		sed -i "s/pegacorn/$FUSIONPBX_DB/g" "/var/lib/postgresql/data/pg_hba.conf"
		cat "/var/lib/postgresql/data/pg_hba.conf"
		echo ""
}

# Executes the main routine with environment variables
# passed through the command line.
main "$@"