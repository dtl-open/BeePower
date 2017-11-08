# Bee Power API
Proof of concept application to explore container based micro services and terraform scripting.

## Run API Locally

`cd MeterReadsAPI`
`dotnet run`

Check things are working
`curl http://localhost:5000/api/meterReads`

## Dockerinzing API

1. Create a docker registry in Docker Hub or ECS registry
2. Build the image
```
    cd MeterReadsAPI`
    docker build -t <your docker registry>/meter-reads-api .
```
3. Push to registry. ex: Docker Hub `docker push <your docker registry>/meter-reads-api`

## Initial Deployment to AWS ECS

1. Go to ContinousDeployment folder
2. Rename terraform.tfvars.template file to terraform.tfvars
3. Fill the variables in the file with respective values
4. Go to ContinousDeployment/InitialDeployment folder
5. Change the variables in common.tf file to avoid naming clashes.
6. Run `terraform init`
7. Then run `terraform plan -var-file="../terraform.tfvars"` to what are the resources going to be created
8. Then run `terraform apply -var-file="../terraform.tfvars"` to create the resources in
