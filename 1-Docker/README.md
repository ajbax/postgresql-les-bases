# Créer une image Docker Postgres avec une DB préchargée

## 1. Création de limage

```Dockerfile
FROM postgres
ENV POSTGRES_PASSWORD inspire#123!
ENV POSTGRES_DB inspiredb
COPY sample.sql /docker-entrypoint-initdb.d/sample.sql
```

```bash

docker image build . -t adistar/postgres:1.0

```

## Credit

Database source: https://github.com/pthom/northwind_psql
