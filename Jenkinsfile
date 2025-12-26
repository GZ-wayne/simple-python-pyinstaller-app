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
        sh '''python -m py_compile sources/add2vals.py sources/calc.py
        '''
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
        sh '''pip install pytest
pytest --verbose --junitxml=test-reports/results.xml sources/test_calc.py
        '''
      }
    }

    stage('Deliver (Docker Multi-Arch)') {
      agent {
        label 'docker'
      }
      steps {
        sh '''docker build -t ${ACR_REGISTRY}/${ACR_NAMESPACE}/${IMAGE_NAME}:latest .
'''
      }
    }

  }
  environment {
    ACR_REGISTRY = 'registry.cn-guangzhou.aliyuncs.com'
    ACR_NAMESPACE = 'wayne-lee'
    IMAGE_NAME = 'python-docker'
    IMAGE_TAG = "latest"
    ACR_CREDENTIALS_ID = 'aliyun-docker-creds'
  }
}