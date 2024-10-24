# This Dockerfile build a Docker image with PostgreSQL and pg_cron,
# PostGIS, pgRouting and Patroni

# PostgreSQL major version
ARG PG_MAJOR=16

# Starting from PostgreSQL image
FROM postgres:$PG_MAJOR as builder

# Create a new image
FROM scratch
COPY --from=builder / /

# PostgreSQL major version
ARG PG_MAJOR=16

# PostgreSQL additional version (will additionally installed beyond the major
# version specified before only if this variable is specified)
ARG ADDITIONAL_PG_MAJORS=""

# Additional locales to be installed (separated by space)
ARG ADDITIONAL_LOCALES=""

# Install pg_cron
ARG INSTALL_PG_CRON=false

# Install PostGIS
ARG INSTALL_POSTGIS=false

# Install pgRouting
ARG INSTALL_PGROUTING=false

# Metadata
LABEL version="1.0"
LABEL description="PostgreSQL & pgBackRest Docker Image"
LABEL maintainer="Mattia Martinello <mattia@mattiamartinello.com>"

# Install additional locales if ADDITIONAL_LOCALES is set
RUN if [ -n "$ADDITIONAL_LOCALES" ]; then \
        locales=$(echo $ADDITIONAL_LOCALES); \
        for locale in $locales; do \
            echo "Installing locale: $locale"; \
            sed -i "/^#\s*${locale}/s/^#\s*//" /etc/locale.gen; \
        done && locale-gen; \
    else \
        echo "No additional locales to install."; \
    fi

# Install pg_cron if enabled
RUN if [ "$INSTALL_PG_CRON" = "true" ]; then \
        apt-get update -y && apt-get install -y \
        postgresql-$PG_MAJOR-cron \
        && rm -rf /var/lib/apt/lists/*; \
    fi

# Install PostGIS if enabled
RUN if [ "$INSTALL_POSTGIS" = "true" ]; then \
        apt-get update -y && apt-get install -y \
        postgresql-$PG_MAJOR-postgis-3 \
        postgresql-$PG_MAJOR-postgis-3-scripts \
        && rm -rf /var/lib/apt/lists/*; \
    fi

# Install pgRouting if enabled
RUN if [ "$INSTALL_PGROUTING" = "true" ]; then \
        apt-get update -y && apt-get install -y \
        postgresql-$PG_MAJOR-pgrouting \
        postgresql-$PG_MAJOR-pgrouting-scripts \
        && rm -rf /var/lib/apt/lists/*; \
    fi

# Install pgBackRest if enabled
RUN apt-get update -y && apt-get install -y \
    pgbackrest \
    && rm -rf /var/lib/apt/lists/*

# Install additionals PostgreSQL versions
# looping through ADDITIONAL_PG_MAJORS array
RUN for ADDITIONAL_PG_MAJOR in $ADDITIONAL_PG_MAJORS; do \
    apt-get update -y && apt-get install -y \
    postgresql-$ADDITIONAL_PG_MAJOR \
    && rm -rf /var/lib/apt/lists/*; \
    done;

# Clean
RUN apt-get clean

# Run PostgreSQL
USER postgres
