#!/bin/bash

cd Deployment
terraform destroy --force --var-file=../terraform.tfvars
