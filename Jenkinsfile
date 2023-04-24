pipeline{
  agent any
  
  environment{
    imagename="vijayalakshmis/banking"
    registryCredential = 'Docker'
    dockerImage = ''
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

   /* stage('Build image') {
      steps{
             sh 'docker build -t vijayalakshmis/banking:latest .'
            
          } 
        }
    stage('Docker Login') {
      steps{
        withCredentials([usernamePassword(credentialsId: 'Docker', passwordVariable: 'pass', usernameVariable: 'un')]) {
          sh "docker login -u ${env.un} -p ${env.pass}"
        }

      }
    }

    stage ('Push Image'){
      steps{
         sh 'docker push vijayalakshmis/banking:latest'
      }


    }*/

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
        sh 'sudo chmod 600 aws.pem'
        sh 'terraform init'
        sh 'terraform validate'
        sh 'terraform apply --auto-approve'
      }
    }
  }
}
