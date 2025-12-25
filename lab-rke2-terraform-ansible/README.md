🚀 RKE2 on GCP – Hạ tầng IaC & GitOps
<p align="center"> <img src="docs/image.png" alt="Sơ đồ kiến trúc" width="85%"> </p> <p align="center"> <b>Terraform · Ansible · RKE2 · ArgoCD · Rancher · GitOps</b> </p>
📑 Mục lục

Mục tiêu dự án

Tổng quan kiến trúc

Pipeline 1 – Hạ tầng & Kubernetes

Pipeline 2 – Triển khai ứng dụng (GitOps)

GitOps với ArgoCD

Quản lý & vận hành cluster với Rancher

Cấu trúc project

Hạn chế hiện tại & hướng phát triển

Kết luận

# 1. Mục tiêu dự án

Dự án xây dựng hệ thống triển khai hạ tầng và Kubernetes tự động trên Google Cloud Platform (GCP), áp dụng:

Infrastructure as Code: Terraform

Configuration Management: Ansible

Kubernetes: RKE2

GitOps: ArgoCD

Mục tiêu:

Tự động hoá hạ tầng cloud

Tự động cài đặt Kubernetes cluster

Triển khai ứng dụng theo GitOps

Chuẩn bị nền tảng mở rộng & vận hành cluster (day-2 operations)

# 2. Tổng quan kiến trúc

Hệ thống gồm 2 pipeline chính:

Pipeline 1 – Hạ tầng & Kubernetes

Terraform tạo hạ tầng GCP (VPC, Subnet, VM)

Ansible cài RKE2 cluster

Cài ArgoCD và Rancher trong cluster

Pipeline 2 – Ứng dụng (GitOps)

CI build & push Docker image

ArgoCD pull Helm chart

Tự động deploy & sync ứng dụng

#  3. Pipeline 1 – Hạ tầng & Kubernetes
## 3.1 Terraform – Tạo hạ tầng GCP

Terraform chịu trách nhiệm:

Tạo VPC, Subnet, Firewall

Tạo VM:

1 VM master (RKE2 server, Rancher, ArgoCD)

1 VM worker (RKE2 agent)

Inject SSH key

Xuất IP & sinh inventory cho Ansible

Terraform chỉ quản lý hạ tầng, không cài phần mềm.

## 3.2 Ansible – Cài RKE2, ArgoCD & Rancher

Ansible thực hiện:

Cài RKE2 server (master)

Cài RKE2 agent (worker)

Join node vào cluster

Cấu hình kubeconfig

Cài ArgoCD

Cài Rancher để quản lý cluster

Toàn bộ được orchestration bằng:

./deploy.sh

# 4. Pipeline 2 – Triển khai ứng dụng (GitOps)

Pipeline GitOps:

Dev push code

CI build & push image

CI update Helm values

ArgoCD tự động sync & deploy

👉 Không cần kubectl apply thủ công.

# 5. GitOps với ArgoCD
## 5.1 Kết nối Helm Repository

Add repo Helm (private)

Xác thực bằng GitHub PAT

ArgoCD theo dõi thay đổi Git

## 5.2 Tạo Application

Khai báo repo, path, namespace

Bật Auto Sync

## 5.3 Luồng GitOps
CI → Update Helm → Git push
→ ArgoCD detect → Sync → Deploy

# 6. Quản lý & vận hành cluster với Rancher

Rancher được cài trực tiếp trong RKE2 cluster để phục vụ day-2 operations:

Quản lý cluster bằng UI

Theo dõi node (CPU, RAM, trạng thái)

Quản lý workload, namespace, RBAC

Tích hợp monitoring (Prometheus, Grafana)

Truy cập Rancher (lab)

Rancher được expose qua NodePort

Truy cập bằng:

https://<MASTER_PUBLIC_IP>.nip.io:<NODEPORT>

#  7. Cấu trúc project
.
├── ansible
│   ├── install-rke2-server.yaml
│   ├── install-rke2-agent.yaml
│   ├── install-argocd.yaml
│   ├── install-rancher.yaml
│   ├── inventory.tpl
│   ├── inventory.ini
│   └── site.yaml
├── terraform
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules
│       ├── network
│       └── vm
├── deploy.sh
└── README.md

#  8. Hạn chế hiện tại & hướng phát triển
Hạn chế

Worker scale còn thủ công

Cluster chỉ có 1 master (chưa HA)

Monitoring mới ở mức cơ bản

Hướng phát triển

Scale worker bằng Terraform (count / for_each)

Import cluster vào Rancher để vận hành

Thêm Monitoring (Prometheus, Grafana)

Nâng cấp HA control-plane

Áp dụng Cluster Autoscaler

#  9. Kết luận

Dự án đã:

Tự động hoá hạ tầng bằng Terraform

Cài Kubernetes bằng Ansible

Triển khai ứng dụng theo GitOps

Quản lý & vận hành cluster bằng Rancher