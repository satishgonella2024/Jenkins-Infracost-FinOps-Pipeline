pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-credentials')
        AWS_SECRET_ACCESS_KEY = credentials('aws-credentials')
        INFRACOST_API_KEY     = credentials('INFRACOST_API_KEY')
    }
    options {
        ansiColor('xterm')
    }
    stages {
        stage('Debug Environment') {
            steps {
                echo "🔍 Starting Environment Debugging..."
                sh '''
                    echo -e "\033[1;34mTerraform version:\033[0m $(terraform version)"
                    echo -e "\033[1;34mInfracost version:\033[0m $(infracost --version)"
                '''
                echo "✅ Environment Debugging Completed!"
            }
        }
        stage('Terraform Init') {
            steps {
                echo "🚀 Initializing Terraform..."
                dir('terraform') {
                    sh 'terraform init'
                }
                echo "✅ Terraform Initialized Successfully!"
            }
        }
        stage('Terraform Plan') {
            steps {
                echo "📜 Generating Terraform Plan..."
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
                echo "✅ Terraform Plan Generated Successfully!"
            }
        }
        stage('Infracost Estimate') {
            steps {
                echo "💰 Generating Infracost Estimate..."
                dir('terraform') {
                    sh '''
                        echo "📝 Running infracost breakdown..."
                        infracost breakdown --path=. --format=json --out-file=infracost.json
                        echo "📊 Generating table format..."
                        infracost output --path=infracost.json --format=table
                        echo "🌐 Generating HTML format..."
                        infracost output --path=infracost.json --format=html --out-file=infracost.html
                    '''
                }
                archiveArtifacts artifacts: 'terraform/infracost.html', fingerprint: true
                echo "✅ Infracost Estimate Generated and Archived!"
            }
        }
    }
    post {
        success {
            echo "🎉 BUILD SUCCESSFUL! Publishing Infracost Report..."
            publishHTML([
                reportDir: 'terraform',
                reportFiles: 'infracost.html',
                reportName: 'Infracost Report',
                alwaysLinkToLastBuild: true,
                allowMissing: false,
                keepAll: true
            ])
            echo "📄 Infracost Report Published Successfully!"
        }
        failure {
            echo "❌ BUILD FAILED! Please check the logs for details."
        }
    }
}