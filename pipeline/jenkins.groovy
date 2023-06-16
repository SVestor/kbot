pipeline {
    agent any
    parameters {

        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'android'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm64', '368', 'arm'], description: 'Pick OS')

    }

    environment {
        REPO = 'https://github.com/SVestor/kbot'
        BRANCH = 'main'
        CREG = "docker.io"
    }
    
    stages {

        stage("clone") {
            steps {
                echo "... CLONNING REPOSITORY ..."
                  git branch: "$BRANCH" , url: "$REPO"
            }
        }

        stage("param") {
            steps {
                echo "Build for platform ${params.OS}"

                echo "Build for arch: ${params.ARCH}"

            }
        }

        stage("test") {
            steps {
                echo "... TEST EXECUTION STARTED ... "
                sh 'make test'
            }
        }

        stage("build") {
            steps {
                echo "... BUILD EXECUTION STARTED ..."
                sh "make build OS=${params.OS} ARCH=${params.ARCH}"
            }
        }

        stage("image") {
            steps {
                script {
                    echo "... BUILD IMAGE EXECUTION STARTED ..."
                    sh "make image OS=${params.OS} ARCH=${params.ARCH}"
                    echo "... image is ready for pushing ..."
                }
            }
        }

        stage("push") {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub')  {
                    sh "make push OS=${params.OS} ARCH=${params.ARCH}"
                    }

                    echo "... IMAGE was successfully pushed to ${CREG} ..."
                }
            }
        }
    }
}
