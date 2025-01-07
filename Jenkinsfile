pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-credentials')
        AWS_SECRET_ACCESS_KEY = credentials('aws-credentials')
        INFRACOST_API_KEY     = credentials('INFRACOST_API_KEY')
    }
    stages {
        stage('Debug Environment') {
            steps {
                sh '''
                    echo "Terraform version: $(terraform version)"
                    echo "Infracost version: $(infracost --version)"
                '''
            }
        }
        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }
        stage('Infracost Estimate') {
            steps {
                dir('terraform') {
                    sh '''
                        infracost breakdown --path=. --format=json --out-file=infracost.json
                        infracost output --path=infracost.json --format=table
                    '''
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
}