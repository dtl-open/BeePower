# Bee Power API
Proof of concept application to explore container based micro services and terraform scripting.

## Run API Locally

`cd MeterReadsAPI`
`dotnet run`

Check things are working
`curl http://localhost:5000/api/meterReads`

## Deploying the service to ECS

Deployments to AWS environments should be handled through Jenkins. This is in progress at the moment.
