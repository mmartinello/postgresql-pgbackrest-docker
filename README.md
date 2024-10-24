PostgreSQL, pg_cron, PostGIS, pgRouting and pgBackRest Docker image
===================================================================

This Docker project builds a Docker image with PostgreSQL with a couple of
plugins and pgBackRest installed on it.

[PostgreSQL](https://www.postgresql.org/) is a free and open-source relational
database management system (RDBMS) emphasizing extensibility and SQL compliance.

[pgBackRest](https://pgbackrest.org/) is a reliable backup and restore solution
for PostgreSQL that seamlessly scales up to the largest databases and
workloads.

[pg_cron](https://github.com/citusdata/pg_cron) is a simple cron-based job
scheduler for PostgreSQL.

[PostGIS](https://postgis.net/) extends the capabilities of the PostgreSQL
relational database by adding support storing, indexing and querying geographic
data.

[pgRouting](https://pgrouting.org/) extends the PostGIS / PostgreSQL geospatial
database to provide geospatial routing functionality.

This Docker image also allows to install additional PostgreSQL major versions
(useful in case of upgrades) and additional locales (useful if you need
specific collations for databases).

## Tags

Tags use the following schema: `<pg_major_version>-<image_variant>`.

Image variants refers to which PostgreSQL extensions are installed

* `pgcron`: pg_cron
* `pgcron-postgis`: pg_cron and PostGIS
* `pgcron-pgrouting`: pg_cron and pgRouting
* `postgis`: PostGIS
* `postgis-pgrouting`: PostGIS and pgRouting
* `pgrouting`: pgRouting

PostgreSQL and pgBackRest are installed in all image variants.

If image variant is not specified, all extensions are installed.

All images are based on Debian.

## Volumes

The following volumes should be configured or mounted for data to be
persistent:

* `/var/lib/postgresql`: the PostgreSQL data directory where PostgreSQL write
data into

## Ports

This Docker image listens on the following ports:

* PostgreSQL port: default `5432`

## Build instructions

### Build arguments (environment variables)

`PG_MAJOR`: set the PostgreSQL major version to be used (default `14`).

`INSTALL_PG_CRON`: **pg_cron** will be installed if this variable is set to
`true`, you can set it to `false` or any other value if you don't want
**pg_cron** to be installed. The default value is `false`.

`INSTALL_POSTGIS`: **PostGis** will be installed if this variable is set to
`true`, you can set it to `false` or any other value if you don't want
**PostGis** to be installed. The default value is `false`.

`INSTALL_PGROUTING`: **pgRouting** will be installed if this variable is set to
`true`, you can set it to `false` or any other value if you don't want
**pgRouting** to be installed. The default value is `false`.

`ADDITIONAL_PG_MAJORS`: to install multiple PostgreSQL major versions in the
image, declare here which major versions have to be installed other than the
main major version declared in `PG_MAJOR`. Multiple major versions should be
separated by spaces.

`ADDITIONAL_LOCALES`: to install multiple additional locales, declare here
which locales you need to be installed other than the default ones.
Multiple locales have to be separated by spaces.

### Installing additional PostgreSQL versions

To install multiple additional versions of PostgreSQL in the image, you can set
the `ADDITIONAL_PG_MAJORS` environment variable with an array containing the
additional major PostgreSQL versions you want to install.

This is particularly useful when you need to perform an upgrade of PostgreSQL
between major versions using the pg_upgrade command, which requires the
binaries of the previous PostgreSQL version you are upgrading from.

For example, to build a Docker image with additional PostgreSQL versions
12 and 13, you can use the following docker build command:

```
docker build --build-arg PG_MAJOR=16 --build-arg ADDITIONAL_PG_MAJORS="12 13" -t my-postgres-pgbackrest-image .
```

### Build the image

You can build the Docker image using the `docker build` command:

```
docker build -t <image_tag> .
```

If you wish to specify some build arguments you can add them with the
`--build-arg` parameter, for example:

```
docker build --build-arg='INSTALL_PG_CRON=false' -t <image_tag> .
```

### Installing additional PostgreSQL versions

To install multiple additional versions of PostgreSQL in the image, you can set
the `ADDITIONAL_PG_MAJORS` environment variable with an array containing the
additional major PostgreSQL versions you want to install.

This is particularly useful when you need to perform an upgrade of PostgreSQL
between major versions using the pg_upgrade command, which requires the
binaries of the previous PostgreSQL version you are upgrading from.

For example, to build a Docker image with additional PostgreSQL versions
12 and 13, you can use the following docker build command:

```
docker build --build-arg PG_MAJOR=16 --build-arg ADDITIONAL_PG_MAJORS="12 13" -t my-postgres-pgbackrest-image .
```

## Maintainer

Mattia Martinello
