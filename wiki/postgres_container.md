Running PostgreSQL in a Docker container
docker run --name postgres-db -e POSTGRES_PASSWORD=mypassword postgres

However, this basic command has limitations. I recommend using additional options:
docker run --name postgres-db \
  -e POSTGRES_PASSWORD=mypassword \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_DB=mydatabase \
  -p 5432:5432 \
  -v postgres-data:/var/lib/postgresql/data \
  -d postgres


 # Configuring PostgreSQL in Docker
 ## Setting up persistent storage with volumes
 docker volume create postgres-data

 docker volume inspect postgres-data

 # Exposing ports to connect to PostgreSQL
 docker run --name postgres-db \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -p 5432:5432 \
  -d postgres

  If you already have Postgesql or another service using port 5432, on your host, you can map to a different port:

  docker run --name postgres-db \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -p 5433:5432 \
  -d postgres

## All network interfaces 
By default, the port is exposed on all network interfaces (0.0.0.0). You can optionally restrict it to localhost for additional security:

docker run --name postgres-db \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -p 127.0.0.1:5432:5432 \
  -d postgres


# Configuring PostgreSQL settings

## Environment variables
docker run --name postgres-db \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_DB=mydatabase \
  -e POSTGRES_INITDB_ARGS="--data-checksums" \
  -e POSTGRES_HOST_AUTH_METHOD=scram-sha-256 \
  -d postgres

  And here's what each of these does:

    POSTGRES_PASSWORD: Sets the superuser password (required).
    POSTGRES_USER: Sets the superuser name (defaults to "postgres").
    POSTGRES_DB: Sets the default database name (defaults to the user name).
    POSTGRES_INITDB_ARGS: Passes arguments to PostgreSQL's initdb command.
    POSTGRES_HOST_AUTH_METHOD: Sets the authentication method.

Some frequently customized PostgreSQL settings are:

    max_connections: Controls how many connections PostgreSQL accepts (default is 100).
    shared_buffers: Sets memory used for caching (default is often too low for production).
    work_mem: Memory used for query operations.
    maintenance_work_mem: Memory used for maintenance operations.

Mount the configuration file to customize PostgreSQL settings:
docker run --name postgres-db \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -v ./my-postgres.conf:/etc/postgresql/postgresql.conf \
  -v postgres-data:/var/lib/postgresql/data \
  -d postgres \
  -c 'config_file=/etc/postgresql/postgresql.conf'


# Connecting to PostgreSQL

## Using psql
docker exec -it postgres-db psql -U myuser -d mydatabase

## Using pgAdmin
Many developers prefer using a graphical tool over a CLI - myself included. pgAdmin is a popular and free choice for PostgreSQL, but the connection process is similar for other tools like DBeaver, DataGrip, or TablePlus.

# Stopping and starting the container
If you want to restart a running container, which can be useful after changing certain configurations, run the following command:

    docker restart postgres-db

In cases when you're completely done with a container and want to remove it, look no further than these two commands:

    docker stop postgres-db
    docker rm postgres-db


# Updating PostgreSQL in Docker

1. To start, pull the latest PostgreSQL image (or a specific version):
    - docker pull postgres:17.5
2. Next, stop and remove the existing container:  

    docker stop postgres-db  
    docker rm postgres-db  

3. Finally, create a new container with the same volume:  

    docker run --name postgres-db \  
    -e POSTGRES_PASSWORD=mysecretpassword \  
    -e POSTGRES_USER=myuser \  
    -e POSTGRES_DB=mydatabase \  
    -v postgres-data:/var/lib/postgresql/data \  
    -p 5432:5432 \  
    -d postgres:17.5  

# Major new versions
If you're upgrading to a major new version (like 17 to 18), PostgreSQL will automatically run any necessary data migrations when it starts. Just keep these things in mind:


    - Major version upgrades should be tested in a non-production environment first.
    - Always back up your data volume before a major version upgrade.
    - Check the PostgreSQL release notes for any breaking changes.

# Backup

To create a backup before upgrading, run the following command:

    docker run --rm 
    -v postgres-data:/data 
    -v $(pwd):/backup postgres:17.4 \
    bash -c "pg_dumpall -U myuser > /backup/postgres_backup.sql"

# Best Practices
- Keep your data safe with regular backups
- automate your backups
- Use named volumes for data persistence
- Securing PostgreSQL in Docker
    - Use strong and unique passwords
    - Restrict network access
    - Use custom PostgreSQL configuration
    - Regularly update your PostgreSQL image


# Troubleshooting PostgreSQL in Docker
## Check the logs for errors
    docker logs postgres-db
## The error could be tied to a permission issue with the mounted volume.
- initdb: could not change permissions of directory "/var/lib/postgresql/data": Operation not permitted
- To solve this issue, check the ownership and permissions of the mounted volume.
## Check the ownership
docker run --rm -v postgres-data:/data alpine ls -la /data

## Check the permissions
docker run --rm -v postgres-data:/data alpine chmod 700 /data

## Check environment variables

    docker run --name postgres-db \
    -e POSTGRES_PASSWORD=mysecretpassword \
    -v postgres-data:/var/lib/postgresql/data \
    -d postgres

## Data directory not empty but missing PostgreSQL files
The “Data directory not empty but missing PostgreSQL files” error is also common. This is the log message you're likely to see:

This usually happens when you've mounted a volume that contains files but not a valid PostgreSQL database. You might need to reinitialize by using a new volume:

    docker volume create postgres-data-new
    docker run --name postgres-db \
    -e POSTGRES_PASSWORD=mysecretpassword \
    -v postgres-data-new:/var/lib/postgresql/data \
    -d postgres

If you need more help troubleshooting, check out this tutorial on Datacamp that goes over the basics of PostgreSQL in Docker:
https://www.datacamp.com/tutorial/postgresql-docker

