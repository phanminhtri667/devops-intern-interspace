pipeline {
    agent any

    environment {
        GITHUB_TOKEN = credentials('github-token-3')
        SSH_KEY = credentials('pmt')
        GCP_SA = credentials('gcp_sa')
    }

    stages {

        stage('Checkout') {
            steps {
                git(
                    url: 'https://github.com/phanminhtri667/devops-intern-interspace.git',
                    branch: 'main',
                    credentialsId: 'github-token'
                )
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                export GOOGLE_APPLICATION_CREDENTIALS=${GCP_SA}
                cd lab-combat-gcp/terraform
                terraform init
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                export GOOGLE_APPLICATION_CREDENTIALS=${GCP_SA}
                cd lab-combat-gcp/terraform
                terraform apply -auto-approve
                '''
            }
        }

        stage('Generate Inventory') {
            steps {
                sh '''
                cd lab-combat-gcp/ansible
                chmod +x generate_inventory.sh
                ./generate_inventory.sh
                '''
            }
        }

        stage('Run Ansible') {
            steps {
                sh '''
                cd lab-combat-gcp/ansible
                ansible-playbook -i inventory.ini playbook.yml
                '''
            }
        }
    }
}
