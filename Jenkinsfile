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
                echo "=================================================="
                echo "              DEBUG ENVIRONMENT                  "
                echo "=================================================="
                sh '''
                    echo "Terraform version:"
                    terraform version
                    echo ""
                    echo "Infracost version:"
                    infracost --version
                '''
                echo "=================================================="
            }
        }
        stage('Terraform Init') {
            steps {
                echo "=================================================="
                echo "           TERRAFORM INITIALIZATION              "
                echo "=================================================="
                dir('terraform') {
                    sh '''
                        echo "Initializing Terraform..."
                        terraform init
                    '''
                }
                echo "Terraform initialization completed successfully!"
                echo "=================================================="
            }
        }
        stage('Terraform Plan') {
            steps {
                echo "=================================================="
                echo "                TERRAFORM PLAN                   "
                echo "=================================================="
                dir('terraform') {
                    sh '''
                        echo "Generating Terraform plan..."
                        terraform plan -out=tfplan
                    '''
                }
                echo "Terraform plan completed successfully!"
                echo "=================================================="
            }
        }
        stage('Infracost Estimate') {
            steps {
                echo "=================================================="
                echo "           INFRACOST COST ESTIMATION             "
                echo "=================================================="
                dir('terraform') {
                    sh '''
                        echo "Calculating cost estimate..."
                        infracost breakdown --path=. --format=json --out-file=infracost.json
                        infracost output --path=infracost.json --format=table
                        infracost output --path=infracost.json --format=html --out-file=infracost.html
                    '''
                }
                echo "Infracost estimate generated successfully!"
                echo "Archiving Infracost report..."
                archiveArtifacts artifacts: 'terraform/infracost.html', fingerprint: true
                echo "=================================================="
            }
        }
    }
    post {
        success {
            echo "=================================================="
            echo "                BUILD SUCCESSFUL                 "
            echo "=================================================="
            echo "Publishing Infracost Report..."
            publishHTML([
                reportDir: 'terraform',
                reportFiles: 'infracost.html',
                reportName: 'Infracost Report',
                alwaysLinkToLastBuild: true,
                allowMissing: false,
                keepAll: true
            ])
            echo "Infracost Report published successfully!"
            echo "=================================================="
        }
        failure {
            echo "=================================================="
            echo "                BUILD FAILED                     "
            echo "=================================================="
            echo "Check the logs for details."
            echo "=================================================="
        }
    }
}