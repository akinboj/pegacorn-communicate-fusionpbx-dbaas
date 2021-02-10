#FROM fhirfactory/pegacorn-base-docker-postgres:1.0.0
FROM postgres:12.4-alpine
LABEL "Product"="PostgreSQL alpine (SSL enabled)"

COPY postgresql.conf /var/lib/postgresql/config/postgresql.conf
COPY pg_hba.conf /var/lib/postgresql/config/pg_hba.conf
COPY init.sql /docker-entrypoint-initdb.d/

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod 600 /var/lib/postgresql/config/postgresql.conf \
 && chown postgres:postgres /var/lib/postgresql/config/postgresql.conf \
 && chmod 600 /var/lib/postgresql/config/pg_hba.conf \
 && chown postgres:postgres /var/lib/postgresql/config/pg_hba.conf \
 && chmod +x /usr/local/bin/docker-entrypoint.sh \
 && ls -la /usr/local/bin

CMD ["postgres", "-c", "config_file=/var/lib/postgresql/config/postgresql.conf", "-c", "hba_file=/var/lib/postgresql/config/pg_hba.conf"]