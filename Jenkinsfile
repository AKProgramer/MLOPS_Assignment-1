pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        IMAGE_NAME = 'akprogramer/ml-salary-predictor'
        DOCKER_HUB_REPO = 'akprogramer/ml-salary-predictor'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from repository...'
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                script {
                    def image = docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
                    docker.build("${IMAGE_NAME}:latest")
                }
            }
        }
        
        stage('Test Docker Image') {
            steps {
                echo 'Testing Docker image...'
                script {
                    docker.image("${IMAGE_NAME}:${BUILD_NUMBER}").inside {
                        sh 'python -c "from application import application; print(\'Application loads successfully\')"'
                    }
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing Docker image to Docker Hub...'
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        def image = docker.image("${IMAGE_NAME}:${BUILD_NUMBER}")
                        image.push()
                        image.push("latest")
                    }
                }
            }
        }
        
        stage('Clean up') {
            steps {
                echo 'Cleaning up local Docker images...'
                sh "docker rmi ${IMAGE_NAME}:${BUILD_NUMBER} || true"
                sh "docker rmi ${IMAGE_NAME}:latest || true"
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
            emailext (
                subject: "Jenkins Job Successful: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
                body: """
                <html>
                <body>
                    <h2>Jenkins Job Completed Successfully</h2>
                    <p><strong>Job Name:</strong> ${env.JOB_NAME}</p>
                    <p><strong>Build Number:</strong> ${env.BUILD_NUMBER}</p>
                    <p><strong>Build URL:</strong> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                    <p><strong>Docker Image:</strong> ${IMAGE_NAME}:${BUILD_NUMBER}</p>
                    <p>The ML Salary Predictor application has been successfully containerized and pushed to Docker Hub.</p>
                    <br>
                    <p>Best regards,<br>CI/CD Pipeline</p>
                </body>
                </html>
                """,
                mimeType: 'text/html',
                to: "${env.ADMIN_EMAIL ?: 'admin@example.com'}"
            )
        }
        
        failure {
            echo 'Pipeline failed!'
            emailext (
                subject: "Jenkins Job Failed: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
                body: """
                <html>
                <body>
                    <h2>Jenkins Job Failed</h2>
                    <p><strong>Job Name:</strong> ${env.JOB_NAME}</p>
                    <p><strong>Build Number:</strong> ${env.BUILD_NUMBER}</p>
                    <p><strong>Build URL:</strong> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                    <p>Please check the build logs for more details.</p>
                    <br>
                    <p>Best regards,<br>CI/CD Pipeline</p>
                </body>
                </html>
                """,
                mimeType: 'text/html',
                to: "${env.ADMIN_EMAIL ?: 'admin@example.com'}"
            )
        }
        
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
    }
}