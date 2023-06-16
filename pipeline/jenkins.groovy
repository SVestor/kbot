pipeline {
    agent any
    parameters {

        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'android'], description: 'Pick OS')
        choice(name: 'arch', choices: ['amd64', 'arm64', '368', 'arm'], description: 'Pick OS')

    }
    stages {
        stage('Example') {
            steps {
                echo "Build for platform ${params.OS}"

                echo "Build for arch: ${params.ARCH}"

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
                sh "make build OS=${params.OS} ARCH=${params.ARCH}"
            }
        }

        stage("image") {
            steps {
                script {
                    echo 'BUILD EXECUTION STARTED'
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
                }
            }
        }
    }
}
