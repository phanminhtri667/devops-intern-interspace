# devops-intern-interspace
# DevOps Auto RKE2 Cluster Builder

### 🧭 Overview
This project automates the creation of a Rancher RKE2 Kubernetes cluster using:
- **Terraform** for infrastructure provisioning (multi-cloud)
- **Ansible** for RKE2 setup
- **YAML config** for cluster definition

### ⚙️ Tools
| Tool         | Purpose                             |
|--------------|-------------------------------------|
| Terraform    | Create VM, network, firewall        |
| Ansible      | Configure RKE2 master and worker    |
| RKE2         | Lightweight Kubernetes distribution |
| Bash         | Wrapper for automation              |

### 🚀 How to Run
```bash
cd scripts
bash run.sh
