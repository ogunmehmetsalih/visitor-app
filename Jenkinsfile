pipeline {
    agent any

    environment {
        IMAGE_NAME = "msalihogun/visitor-app"
        IMAGE_TAG = "v${BUILD_NUMBER}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/ogunmehmetsalih/visitor-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Update Deployment YAML') {
            steps {
                sh "sed -i '' 's|image: ${IMAGE_NAME}:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|' k8s/deployment.yaml"
            }
        }

        stage('Push updated deployment.yaml') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-creds', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                    sh '''
                        git config --global user.email "jenkins@example.com"
                        git config --global user.name "jenkins"
                        git add k8s/deployment.yaml
                        git commit -m "Update image tag to ${IMAGE_TAG} [ci skip]" || echo "No changes to commit"
                        git push https://${GIT_USER}:${GIT_PASS}@github.com/ogunmehmetsalih/visitor-app.git HEAD:master
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh "kubectl apply -f k8s/deployment.yaml"
                sh "kubectl apply -f k8s/service.yaml"
            }
        }
    }
}

