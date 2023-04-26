pipeline{
  agent any
  
  environment{
    imagename="vijayalakshmis/banking"
    registryCredential = 'Docker'
    dockerImage = ''
//    AWS_ACCESS_KEY_ID = ''
  //  AWS_SECRET_ACCESS_KEY = ''
    //AWS_DEFAULT_REGION = 'us-east-1'
       
  }

  tools
  {
    maven 'MAVEN_3'
  }
  stages{
    stage('Checkout'){
      steps{
        echo 'Checkout the source code'
        git 'https://github.com/vijayalakshmi-github/banking.git'
      }
    }

    stage('Build'){
      steps{
        echo 'Packaging'
        sh 'mvn clean package'
      }
    }

    stage('Generate test report'){
      steps{
        publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/banking/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Test Report', reportTitles: '', useWrapperFileDirectly: true])
      }
    }

 
    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build imagename
        }
      }
    }
    stage('Push Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
             dockerImage.push('latest')
          }
        }
      }
    }
    stage ('Configure and Deploy Prod-server with Terraform, Ansible'){
      steps{
        
        sh 'chmod 700 aws.pem'
        sh 'terraform init'
        sh 'terraform validate'
        sh 'terraform apply --auto-approve'
      }
    }
  }
}
