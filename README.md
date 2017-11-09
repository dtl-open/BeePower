# Bee Power API
Proof of concept application to explore container based micro services and terraform scripting.

## Run API Locally

`cd MeterReadsAPI`
`dotnet run`

Check things are working
`curl http://localhost:5000/api/meterReads`

## Deploying the service to ECS

1. Go to ContinousDeployment folder
2. Rename terraform.tfvars.template file to terraform.tfvars
3. Fill the variables in the file with respective values
4. Go to ContinousDeployment/Deployment folder
5. Change the variables in common.tf file to avoid naming clashes.
6. Run `./deploy.sh <version>` (Provide version number which is not used to tag the docker image.)

## Tear down resources and services
1. Go to ContinousDeployment folder
2. Run `./tear-down.sh`
