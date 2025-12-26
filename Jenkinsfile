pipeline {
  agent none
  stages {
    stage('Build') {
      agent {
        docker {
          image 'python:3.11-slim'
        }

      }
      steps {
        sh 'python -m py_compile sources/add2vals.py sources/calc.py'
      }
    }

    stage('Test') {
      agent {
        docker {
          image 'python:3.11-slim'
        }

      }
      post {
        always {
          junit 'test-reports/results.xml'
        }

      }
      steps {
        sh '''pip install --proxy http://admin:123@10.0.0.143:8081/repository/proxy/ pytest

pytest --junitxml=test-reports/results.xml sources/test_calc.py
        '''
      }
    }

    stage('Build Docker Image') {
      agent {
        label 'docker'
      }
      steps {
        sh '''docker build -t ${ACR_REGISTRY}/${ACR_NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG} .
        '''
      }
    }

    stage('Login & Push Image') {
      agent {
        label 'docker'
      }
      steps {
        withCredentials(bindings: [
                                        usernamePassword(
                                                credentialsId: ACR_CREDENTIALS_ID,
                                                usernameVariable: 'ACR_USERNAME',
                                                passwordVariable: 'ACR_PASSWORD'
                                              )
                                            ]) {
              sh '''echo "$ACR_PASSWORD" | docker login  -u "$ACR_USERNAME"  --password-stdin  $ACR_REGISTRY

docker push $ACR_REGISTRY/$ACR_NAMESPACE/$IMAGE_NAME:$IMAGE_TAG
          '''
            }

          }
        }

      }
      environment {
        ACR_REGISTRY = 'registry.cn-guangzhou.aliyuncs.com'
        ACR_NAMESPACE = 'wayne-lee'
        IMAGE_NAME = 'python-docker'
        IMAGE_TAG = 'latest'
        ACR_CREDENTIALS_ID = 'aliyun-docker-creds'
      }
    }