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
                ansiColor('xterm') {
                    sh '''
                        echo "\033[34m================ DEBUG INFORMATION =================\033[0m"
                        echo "\033[32mTerraform version:\033[0m $(terraform version)"
                        echo "\033[32mInfracost version:\033[0m $(infracost --version)"
                        echo "\033[34m===================================================\033[0m"
                    '''
                }
            }
        }
        stage('Terraform Init') {
            steps {
                ansiColor('xterm') {
                    echo "\033[34mInitializing Terraform...\033[0m"
                    dir('terraform') {
                        sh '''
                            echo "\033[33mRunning terraform init...\033[0m"
                            terraform init
                        '''
                    }
                    echo "\033[32mTerraform initialization completed.\033[0m"
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                ansiColor('xterm') {
                    echo "\033[34mCreating Terraform Plan...\033[0m"
                    dir('terraform') {
                        sh '''
                            echo "\033[33mRunning terraform plan...\033[0m"
                            terraform plan -out=tfplan
                        '''
                    }
                    echo "\033[32mTerraform plan completed.\033[0m"
                }
            }
        }
        stage('Infracost Estimate') {
            steps {
                ansiColor('xterm') {
                    echo "\033[34mGenerating Infracost Estimate...\033[0m"
                    dir('terraform') {
                        sh '''
                            echo "\033[33mRunning infracost breakdown...\033[0m"
                            infracost breakdown --path=. --format=json --out-file=infracost.json
                            echo "\033[33mGenerating table format...\033[0m"
                            infracost output --path=infracost.json --format=table
                            echo "\033[33mGenerating HTML format...\033[0m"
                            infracost output --path=infracost.json --format=html --out-file=infracost.html
                        '''
                    }
                    echo "\033[32mInfracost estimate generated and archived.\033[0m"
                }
                archiveArtifacts artifacts: 'terraform/infracost.html', fingerprint: true
            }
        }
    }
    post {
        success {
            ansiColor('xterm') {
                echo "\033[42;30mBUILD SUCCESSFUL! Publishing Infracost Report...\033[0m"
            }
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
            ansiColor('xterm') {
                echo "\033[41;30mBUILD FAILED! Please check the logs for details.\033[0m"
            }
        }
    }
}