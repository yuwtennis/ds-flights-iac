
## Pre-requisite

Below tool will be required when running on local pc.  
_Tested version_ in the table represents the version which I have used for testing.

| Tool name         | Tested version                                                |
|-------------------|---------------------------------------------------------------|
| terraform         | see [main.tf](terraform/main.tf)                              |

## Tutorial

### Prepare environment

Set up cloud resource

```shell
cd terraform
terraform init
terraform plan
terraform apply
```

### Post deployment procedures

#### Set environment variable

```shell
export GOOGLE_CLOUD_PROJECT=$(gcloud config get core/project)
```

#### Set default password for user `postgres`

```shell
gcloud sql users set-password postgres --instance YOUR_INSTNACE_NANE --prompt-for-password
```

Connect to database.

```shell
psql -U postgres -h localhost -p 5432 sslmode=disable -dbname=postgres
```

#### Setup user for automatic IAM authentication

[Automatic IAM auth is the recommended architecture for now](https://cloud.google.com/sql/docs/postgres/iam-authentication#auto-iam-auth).
Create the service account user in the database.

https://cloud.google.com/sql/docs/postgres/add-manage-iam-users#creating-a-database-user

```shell
gcloud sql users create cloud-sql-auth-proxy@dsongcp-452504.iam \
  --instance flights\
  --type=cloud_iam_service_account
```

Impersonate the service account and login.

```shell
gcloud auth application-default login \
  --impersonate-service-account=cloud-sql-auth-proxy@dsongcp-452504.iam.gserviceaccount.com
```

Due to the google cloud specification, login user must be same with the account that auth proxy had used.

https://cloud.google.com/sql/docs/postgres/iam-logins#log-in-with-automatic

Connect to database.

```shell
psql -U cloud-sql-auth-proxy@dsongcp-452504.iam -h localhost -p 5432 --dbname=postgres
```

> When using a Cloud SQL connector with automatic IAM database authentication, 
> the IAM account that you use to start the connector must be the same account that authenticates to the database.

## Managing cost

TODO MentionWrite about cost management