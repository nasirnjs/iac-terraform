
## Connect Securely to Amazon RDS PostgreSQL Using SSL from Ubuntu
```
# Download AWS RDS SSL Certificate Bundle
curl -o global-bundle.pem https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem

# Set RDS Endpoint
export RDSHOST="prod-postgresql.cdmqiqkkubo9.us-east-2.rds.amazonaws.com"

# Connect Securely to PostgreSQL RDS
psql "host=$RDSHOST port=5432 dbname=appdb user=postgres sslmode=verify-full sslrootcert=./global-bundle.pem"
```