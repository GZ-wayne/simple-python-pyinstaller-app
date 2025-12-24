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
        sh 'docker build -t yourrepo/add2vals:arm64 .'
      }
    }

  }
  environment {
    IMAGE_NAME = 'yourrepo/add2vals'
    IMAGE_TAG = "${env.BUILD_NUMBER}"
  }
}