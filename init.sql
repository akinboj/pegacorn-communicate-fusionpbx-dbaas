/* Create roles and grant privileges to users */
CREATE USER fusionpbx WITH PASSWORD 'Peg@corn';
CREATE ROLE fusionpbx WITH SUPERUSER LOGIN PASSWORD 'Peg@corn';
CREATE ROLE freeswitch WITH SUPERUSER LOGIN PASSWORD 'Peg@corn';

GRANT ALL PRIVILEGES ON DATABASE freeswitch to freeswitch;
GRANT ALL PRIVILEGES ON DATABASE fusionpbx to fusionpbx;
GRANT ALL PRIVILEGES ON DATABASE freeswitch to fusionpbx;

/* Create tables required for Fusionpbx registration */
CREATE TABLE IF NOT EXISTS v_domains (
	domain_uuid VARCHAR
	);
CREATE TABLE IF NOT EXISTS v_software (
	domain_uuid VARCHAR
	);
CREATE TABLE IF NOT EXISTS v_default_settings (
	domain_uuid VARCHAR
	);
CREATE TABLE IF NOT EXISTS fusionpbx.v_domains (
	domain_uuid VARCHAR
	);
CREATE TABLE IF NOT EXISTS fusionpbx.v_fax_logs (
	fax_log_uuid VARCHAR
	);
CREATE TABLE IF NOT EXISTS fusionpbx.v_xml_cdr (
	xml_cdr_uuid VARCHAR
	);
CREATE TABLE IF NOT EXISTS fusionpbx.v_conference_sessions (
	conference_session_uuid VARCHAR
	);
CREATE TABLE IF NOT EXISTS fusionpbx.v_conference_session_details (
	conference_session_detail_uuid VARCHAR
	);

/* Configure Fusionpbx domain entry */
INSERT INTO v_domains (domain_uuid)
VALUES (pegacorn-fusionpbx.site-a)
ON CONFLICT DO NOTHING;
