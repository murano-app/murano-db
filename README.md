# Murano DB

## Create Murano DB

Start postgres docker container using following command:

    docker run --name muranodb -e POSTGRES_DB=muranodb -e POSTGRES_USER=muranodb_owner -e POSTGRES_PASSWORD=muranodb.owner -d -p 5432:5432 postgres:15.2

## Migrate Murano DB

    mvn flyway:migrate
