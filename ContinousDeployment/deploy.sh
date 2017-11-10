#!/bin/bash

# Make sure jq (https://stedolan.github.io/jq/) and terraform is installed in the host machine.

DOCKER_IMAGE=408673749050.dkr.ecr.ap-southeast-2.amazonaws.com/bee-power:$1

# 1. Build project
cd ../MeterReadsAPI && dotnet publish

# 2. Build docker image
docker build -t $DOCKER_IMAGE .

# 3. Docker push with version tag
docker push $DOCKER_IMAGE
echo Successfuly pushed $DOCKER_IMAGE to docker hub.

# 4. Update Task Definition to use the new version
cd ../ContinousDeployment
jq '.[0].image = "'$DOCKER_IMAGE'"' TaskDefinitions/meterReadsApi.json > tmp.$$.json && mv tmp.$$.json TaskDefinitions/meterReadsApi.json && rm tmp.$$.json
echo Updated meterReadsApi.json.
cat TaskDefinitions/meterReadsApi.json

# 5. Create new Task Definition and Update ECS service to use new task definition
cd Deployment
terraform init
terraform plan --var-file=../terraform.tfvars
terraform apply --var-file=../terraform.tfvars
