import groovy.json.JsonOutput
import groovy.json.JsonSlurperClassic

def releaseVersion = '1.0.' +  env.BUILD_NUMBER
def dockerImage = '408673749050.dkr.ecr.ap-southeast-2.amazonaws.com/bee-power:' + releaseVersion
//def dockerImage = 'dilunika/meter-reads-api:' + releaseVersion

node {

  stage('Checkout') {

        try {
            git url: 'https://github.com/dtl-open/BeePower.git'

        } catch(Exception e){
            def message = 'Failed to checkout from repository. ' + e.message
            logBuildFaliures(message)
            throw e
        }
  }

  stage('Build') {


      try {

            dir('MeterReadsAPI') {
                sh 'pwd'
                sh 'dotnet publish'
            }


        } catch(Exception e){
            def message = 'Failed to build binaries. ' + e.message
            logBuildFaliures(message)
            throw e
        }

  }

  stage('Dockerize') {


      try {

            def dockerBuildCommand = 'docker build -t ' +  dockerImage + ' .'
            def dockerPushCommand = 'docker push ' + dockerImage

            dir('MeterReadsAPI') {

                // docker.withRegistry("https://408673749050.dkr.ecr.ap-southeast-2.amazonaws.com", "ecr:ap-southeast-2:aws-cdguy-keys") {
                //     docker.image(dockerImage).push()
                // }
                sh 'pwd'
                sh dockerBuildCommand
                sh dockerPushCommand

                println 'Successfuly pushed ' + dockerImage + 'to ECR.'
            }

        } catch(Exception e){
            def message = 'Failed dockerize binaries. ' + e.message
            logBuildFaliures(message)
            throw e
        }

  }

   stage('Update Task Definition') {


       try {
            // def fileModifyCommand = '''jq '.[0].image = "'' + $dockerImage + '"' TaskDefinitions/meterReadsApi.json > tmp.$$.json && mv tmp.$$.json TaskDefinitions/meterReadsApi.json'''


            dir('ContinousDeployment'){
                def ups = updateTaskDefinetion(dockerImage)
                writeFile file: 'TaskDefinitions/meterReadsApi.json', text: ups
                // sh fileModifyCommand
                sh 'cat TaskDefinitions/meterReadsApi.json'
            }

        } catch(Exception e){
            def message = 'Failed to update Task Definition. ' + e.message
            logBuildFaliures(message)
            throw e
        }

   }

  stage('Deploy') {

      try {

            dir('ContinousDeployment/Deployment'){
                withCredentials([usernamePassword(credentialsId: 'aws-cdguy-keys', passwordVariable: 'SECRET_KEY', usernameVariable: 'ACCESS_KEY')]) {
                    def privateKey = '/home/ubuntu/.ssh/DTL-SYD-SERVERS.pem'

                    def planCommand = "terraform plan --var 'aws_access_key=" + ACCESS_KEY + "' --var 'aws_secret_key=" + SECRET_KEY +  "' --var 'private_key_path=" + privateKey + "'"
                    def applyCommand = "terraform apply --var 'aws_access_key=" + ACCESS_KEY + "' --var 'aws_secret_key=" + SECRET_KEY + "' --var 'private_key_path=" + privateKey + "'"

                    sh 'terraform init'
                    sh planCommand
                    sh applyCommand
                }

            }

        } catch(Exception e){
            def message = 'Failed to Deploy to ECS. ' + e.message
            logBuildFaliures(message)
            throw e
        }

  }

}

def logBuildFaliures(message) {
    println message
}

def updateTaskDefinetion(dockerImage) {

    String fileContents = readFile 'TaskDefinitions/meterReadsApi.json'
    def slurper = new groovy.json.JsonSlurperClassic()
    def json = slurper.parseText(fileContents)

    json[0].image = dockerImage

    def modifiedJson = JsonOutput.toJson(json)
    modifiedJson = JsonOutput.prettyPrint(modifiedJson)

    return modifiedJson
}
