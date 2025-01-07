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
                        infracost output --path=infracost.json --format=html --out-file=infracost.html
                    '''
                }
                archiveArtifacts artifacts: 'terraform/infracost.html', fingerprint: true
            }
        }
    }
    post {
        success {
            publishHTML([
                reportDir: 'terraform',
                reportFiles: 'infracost.html',
                reportName: 'Infracost Report',
                alwaysLinkToLastBuild: true,
                allowMissing: false,
                keepAll: true
            ])
        }
        failure {
            echo 'Build failed. Please check the logs for details.'
        }
    }
}