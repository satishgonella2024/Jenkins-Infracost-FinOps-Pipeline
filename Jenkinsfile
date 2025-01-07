pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-credentials')
        AWS_SECRET_ACCESS_KEY = credentials('aws-credentials')
        INFRACOST_API_KEY     = credentials('INFRACOST_API_KEY')
    }
    options {
        ansiColor('xterm') // Enables colorized output
    }
    stages {
        stage('Debug Environment') {
            steps {
                echo "\u001B[34m🔍 ====== DEBUG ENVIRONMENT ======\u001B[0m" // Blue text
                sh '''
                    echo -e "\033[32m🌐 Terraform version:\033[0m"
                    terraform version
                    echo -e "\033[32m🌐 Infracost version:\033[0m"
                    infracost --version
                '''
            }
        }
        stage('Terraform Init') {
            steps {
                echo "\u001B[34m🛠️ ====== TERRAFORM INITIALIZATION ======\u001B[0m" // Blue text
                dir('terraform') {
                    sh '''
                        echo -e "\033[33m📦 Initializing Terraform...\033[0m"
                        terraform init
                    '''
                }
                echo "\u001B[32m✅ Terraform initialization completed!\u001B[0m" // Green text
            }
        }
        stage('Terraform Plan') {
            steps {
                echo "\u001B[34m📜 ====== TERRAFORM PLAN ======\u001B[0m" // Blue text
                dir('terraform') {
                    sh '''
                        echo -e "\033[33m🔄 Generating Terraform plan...\033[0m"
                        terraform plan -out=tfplan
                    '''
                }
                echo "\u001B[32m✅ Terraform plan completed!\u001B[0m" // Green text
            }
        }
        stage('Infracost Estimate') {
            steps {
                echo "\u001B[34m💰 ====== INFRACOST ESTIMATE ======\u001B[0m" // Blue text
                dir('terraform') {
                    sh '''
                        echo -e "\033[33m🔄 Running infracost breakdown...\033[0m"
                        infracost breakdown --path=. --format=json --out-file=infracost.json
                        
                        echo -e "\033[32m📊 Generating table format...\033[0m"
                        infracost output --path=infracost.json --format=table
                        
                        echo -e "\033[32m🌐 Generating HTML format...\033[0m"
                        infracost output --path=infracost.json --format=html --out-file=infracost.html
                    '''
                }
                archiveArtifacts artifacts: 'terraform/infracost.html', fingerprint: true
                echo "\u001B[32m✅ Infracost estimate generated and archived.\u001B[0m" // Green text
            }
        }
    }
    post {
        success {
            echo "\u001B[32m🎉 BUILD SUCCESSFUL!\u001B[0m" // Green text
            echo "\u001B[34m📂 Publishing Infracost Report...\u001B[0m" // Blue text
            publishHTML([
                reportDir: 'terraform',
                reportFiles: 'infracost.html',
                reportName: 'Infracost Report',
                alwaysLinkToLastBuild: true,
                allowMissing: false,
                keepAll: true
            ])
            echo "\u001B[32m✅ Infracost Report published successfully!\u001B[0m" // Green text
        }
        failure {
            echo "\u001B[31m❌ BUILD FAILED. Check the logs for details.\u001B[0m" // Red text
        }
    }
}