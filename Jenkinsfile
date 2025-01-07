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
                // Verify environment setup
                sh '''
                    echo "Terraform version: $(terraform version)"
                    echo "Infracost version: $(infracost --version)"
                '''
            }
        }
        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    // Generate Terraform plan
                    sh 'terraform plan -out=tfplan'
                }
            }
        }
        stage('Infracost Estimate') {
            steps {
                dir('terraform') {
                    // Generate Infracost JSON and table report
                    sh '''
                        infracost breakdown --path=. --format=json --out-file=infracost.json
                        infracost output --path=infracost.json --format=table
                    '''
                    // Generate Infracost HTML report
                    sh '''
                        infracost output --path=infracost.json --format=html --out-file=infracost.html
                    '''
                }
                // Archive HTML report as a build artifact
                archiveArtifacts artifacts: 'terraform/infracost.html', fingerprint: true
            }
        }
    }
    post {
        success {
            // Publish HTML report using Jenkins HTML Publisher Plugin
            publishHTML([
                reportDir: 'terraform',
                reportFiles: 'infracost.html',
                reportName: 'Infracost Report',
                keepAll: true
            ])
        }
        failure {
            echo 'Build failed. Please check the logs for details.'
        }
    }
}