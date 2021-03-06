pipeline {
  agent any
  options {
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '5'))
    timeout(time: 1, unit: 'HOURS')
  }
  stages {
    stage('Setup') {
      steps {
        slackSend channel: "#builds", message: "Build <${env.BUILD_URL}|#${env.BUILD_NUMBER}> of ${env.JOB_NAME} has been started by ${env.GIT_AUTHOR_NAME}"
        sh 'export'
      }
    }
    stage('Build (Tagged)') {
      when {
        expression {
          env.TAG_NAME != null
        }
      }
      steps {
        sh 'docker build --tag dreamcove/build-aws:${TAG_NAME} .'
      }
    }
    stage('Build (Latest)') {
      when {
        expression {
          env.TAG_NAME == null
        }
      }
      steps {
        sh 'docker build --tag dreamcove/build-aws:latest .'
      }
    }
    stage('Publish') {
      when {
        anyOf {
          expression { env.BRANCH_NAME == 'master' }
          expression { env.TAG_NAME != null }
        }
      }
      steps {
        withCredentials([
          string(credentialsId: 'DOCKER_PASSWORD', variable: 'DOCKER_PASSWORD'),
        ]) {
          sh 'docker login --username vaporofnuance --password ${DOCKER_PASSWORD} && docker push dreamcove/build-aws'
        }
      }
    }
  }
  post {
    success {
      slackSend channel: "#builds", message: "Build <${env.BUILD_URL}|#${env.BUILD_NUMBER}> of ${env.JOB_NAME} completed successfully"
    }
    failure {
      slackSend channel: "#builds", message: "Build <${env.BUILD_URL}|#${env.BUILD_NUMBER}> of ${env.JOB_NAME} failed"
    }
  }
}