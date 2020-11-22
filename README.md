# Murano DB

## Install postgresDB
 Run Postgres DB docker container replacing placeholder with appropriate values:

    docker run --name postgresDB -e POSTGRES_PASSWORD=[password] -e POSTGRES_USER=postgres -d -p 5432:5432 postgres
    
 Run following psql as superadmin user:

    CREATE DATABASE muranodb;
    CREATE USER muranodb_owner WITH ENCRYPTED PASSWORD 'muranodb.owner';
    GRANT ALL PRIVILEGES ON DATABASE muranodb TO muranodb_owner;
 
 ## Migrate Murano DB
    mvn flyway:migrate
 
 