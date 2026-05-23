pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKERHUB_USERNAME     = "${DOCKERHUB_CREDENTIALS_USR}"
        IMAGE_NAME             = "${DOCKERHUB_USERNAME}/flask-cicd-app"
        IMAGE_TAG              = "${BUILD_NUMBER}"
        EC2_HOST               = credentials('ec2-host')
        EC2_SSH_KEY            = credentials('ec2-ssh-key')
    }

    stages {

        stage('Checkout') {
            steps {
                echo '==> Cloning repository...'
                checkout scm
            }
        }

        stage('Test') {
            steps {
                echo '==> Running unit tests...'
                sh '''
                    pip3 install -r app/requirements.txt --quiet
                    cd app && pytest test_app.py -v
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '==> Building Docker image...'
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo '==> Pushing image to DockerHub...'
                sh '''
                    echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    docker push ${IMAGE_NAME}:latest
                    docker logout
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                echo '==> Deploying to AWS EC2...'
                sshagent(['ec2-ssh-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} "
                            docker pull ${IMAGE_NAME}:latest
                            docker stop flask-app || true
                            docker rm flask-app   || true
                            docker run -d \
                                --name flask-app \
                                -p 80:5000 \
                                --restart always \
                                ${IMAGE_NAME}:latest
                        "
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline succeeded. App deployed at http://${EC2_HOST}"
        }
        failure {
            echo 'Pipeline failed. Check logs above.'
        }
        always {
            sh 'docker image prune -f || true'
        }
    }
}
