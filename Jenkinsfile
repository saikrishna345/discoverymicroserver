// node {
// stage('git scm'){
//   git credentialsId: '6ed221e2-1344-4cda-80f4-7b935c4f5b53', url: 'https://github.com/saikrishna345/discoveryservice.git'
//     }
// stage ('mvn package'){
//     sh 'mvn clean package'
// }
// stage('docker build'){
//    sh 'docker build -t saidoc47/discovery-microservice-server:2.0.0 .'
// }
// stage('docker image'){
//    sh  'docker login -u saidoc47 --password-stdin < ~/Spring-boot-with-docker/discovery-microservice-server/dockercredintials.txt' 
//     sh 'docker push saidoc47/discovery-microservice-server:2.0.0'
// }
// stage('docker in dev-server'){
//     sh 'docker run -p 1414:1111 -d saidoc47/discovery-microservice-server:2.0.0'
// }
//  stage('Email')  {
//            mail bcc: '', body: "${env.JOB_NAME} : ${env.BUILD_NUMBER} is ${currentBuild.currentResult}  ", cc: '', from: '', replyTo: '', subject: 'Jenkins pipeline status', to: 'saikrishnamulkanuri5@gmail.com'
//         }
// }

node {
  def project = 'discovery-microservice-server'
  def appName = 'discoveryservice'
  def serviceName = "${appName}-backend"  
  def imageVersion = 'development'
  def namespace = 'development'
  def imageTag = "gcr.io/${project}/${appName}:${imageVersion}.${env.BUILD_NUMBER}"


stage('git scm'){
  git credentialsId: '6ed221e2-1344-4cda-80f4-7b935c4f5b53', url: 'https://github.com/saikrishna345/discoveryservice.git'
    }
stage ('mvn package'){
    sh 'mvn clean package'
    }
stage('docker build'){
     sh "docker build -t ${imageTag} ."
    }
stage('Push image to registry') {
      sh "gcloud docker -- push ${imageTag}"
    } 
stage('Deploy Application') {
       switch (namespace) {
              //Roll out to Dev Environment
              case "development":
                   // Create namespace if it doesn't exist
                   sh("kubectl get ns ${namespace} || kubectl create ns ${namespace}")
           //Update the imagetag to the latest version
                   sh("sed -i.bak 's#gcr.io/${project}/${appName}:${imageVersion}#${imageTag}#' ./k8s/development/*.yaml")
                   //Create or update resources
           sh("kubectl --namespace=${namespace} apply -f k8s/development/deployment.yaml")
                   sh("kubectl --namespace=${namespace} apply -f k8s/development/service.yaml")
           //Grab the external Ip address of the service
                   sh("echo http://`kubectl --namespace=${namespace} get service/${feSvcName} --output=json | jq -r '.status.loadBalancer.ingress[0].ip'` > ${feSvcName}")
                   break
        // //Roll out to Dev Environment
        //       case "production":
        //            // Create namespace if it doesn't exist
        //            sh("kubectl get ns ${namespace} || kubectl create ns ${namespace}")
        //    //Update the imagetag to the latest version
        //            sh("sed -i.bak 's#gcr.io/${project}/${appName}:${imageVersion}#${imageTag}#' ./k8s/production/*.yaml")
        //    //Create or update resources
        //            sh("kubectl --namespace=${namespace} apply -f k8s/production/deployment.yaml")
        //            sh("kubectl --namespace=${namespace} apply -f k8s/production/service.yaml")
        //    //Grab the external Ip address of the service
        //            sh("echo http://`kubectl --namespace=${namespace} get service/${feSvcName} --output=json | jq -r '.status.loadBalancer.ingress[0].ip'` > ${feSvcName}")
        //            break
       
              default:
                   sh("kubectl get ns ${namespace} || kubectl create ns ${namespace}")
                   sh("sed -i.bak 's#gcr.io/${project}/${appName}:${imageVersion}#${imageTag}#' ./k8s/development/*.yaml")
                   sh("kubectl --namespace=${namespace} apply -f k8s/development/deployment.yaml")
                   sh("kubectl --namespace=${namespace} apply -f k8s/development/service.yaml")
                   sh("echo http://`kubectl --namespace=${namespace} get service/${feSvcName} --output=json | jq -r '.status.loadBalancer.ingress[0].ip'` > ${feSvcName}")
                   break
  }

}

