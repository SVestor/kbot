pipeline {
agent any
    environment {
        REPO = 'https://github.com/SVestor/kbot'
        BRANCH = 'main'
    }
    stages {
        
        stage("clone") {
            steps {
                echo 'CLONE REPOSITORY'
                  git branch: "$BRANCH" , url: "$REPO"
            }
        }
        
        stage("test") {
            steps {
                echo 'BUILD EXECUTION STARTED'
                sh 'make test'
            }
        }
        
        stage("build") {
            steps {
                echo 'BUILD EXECUTION STARTED'
                sh 'make build'
            }
        }
        
        stage("image") {
            steps {
                script {
                    echo 'BUILD EXECUTION STARTED'
                    sh 'make image'
                    echo "... image is ready for pushing ..."
                }
            }
        }
        
        stage("push") {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub')  {
                    sh 'make push'
                    }
                }
            }
        }
    }
}
