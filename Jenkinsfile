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
        sh '''
          python -m py_compile sources/add2vals.py sources/calc.py
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
        sh '''
          pip install pytest
          pytest --verbose --junitxml=test-reports/results.xml sources/test_calc.py
        '''
      }
    }

    stage('Deliver (Docker Multi-Arch)') {
      agent {
        label 'docker'
      }
      steps {
        sh '''
          docker buildx create --use --name multiarch-builder || true

          docker buildx build             --platform linux/amd64,linux/arm64             -t ${IMAGE_NAME}:${IMAGE_TAG}             -t ${IMAGE_NAME}:latest             --push .
        '''
      }
    }

  }
  environment {
    IMAGE_NAME = 'yourrepo/add2vals'
    IMAGE_TAG = "${env.BUILD_NUMBER}"
  }
}