# Murano DB

## Install postgresDB
 Run Postgres DB docker container replacing placeholder with appropriate value:

    docker run --name postgresDB -e POSTGRES_PASSWORD=[password] -e POSTGRES_USER=postgres -d -p 5432:5432 postgres
    
 Connect to DB as superadmin user using credentials from previous command and run following psql:

    CREATE DATABASE muranodb;
    CREATE USER muranodb_owner WITH ENCRYPTED PASSWORD 'muranodb.owner';
    GRANT ALL PRIVILEGES ON DATABASE muranodb TO muranodb_owner;
 
 ## Migrate Murano DB
    mvn flyway:migrate -Plocal



# Murano DB

## Install postgres
Start postgres docker container using following command:

    docker run --name muranodb -e POSTGRES_DB=muranodb -e POSTGRES_USER=muranodb_owner -e POSTGRES_PASSWORD=muranodb.owner -d -p 5432:5432 postgres:13

Connect to the 

## Migrate Murano DB
    mvn flyway:migrate -Plocal
