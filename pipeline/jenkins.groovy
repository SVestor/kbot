pipeline {
    agent any
    parameters {

        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'all'], description: 'Pick OS')

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
    }
}
