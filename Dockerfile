FROM fhirfactory/pegacorn-base-docker-postgres:1.0.0
LABEL "Product"="PostgreSQL alpine (SSL enabled)"

COPY docker-entrypoint.sh /docker-entrypoint-initdb.d/
COPY pg_hba.conf /var/lib/postgresql/config/pg_hba.conf
RUN chmod 600 /var/lib/postgresql/config/pg_hba.conf \
    && chown postgres:postgres /var/lib/postgresql/config/pg_hba.conf

ARG IMAGE_BUILD_TIMESTAMP
ENV IMAGE_BUILD_TIMESTAMP=${IMAGE_BUILD_TIMESTAMP}
RUN echo IMAGE_BUILD_TIMESTAMP=${IMAGE_BUILD_TIMESTAMP}