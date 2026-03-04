# Lab: Terraform + GCP + RKE2 + Rancher + ArgoCD

## 1. Mục tiêu
Mục tiêu của lab này là:
- Sử dụng **Terraform** để triển khai hạ tầng trên **Google Cloud Platform (GCP)**
- Tạo **VPC, Subnet, Firewall**
- Tạo **VM master và VM worker**
- Cài đặt **RKE2 (Kubernetes)** trên các VM
- Cài **Docker và Rancher** trên VM master
- Sau khi cluster ổn định, tạo **namespace ArgoCD** và cài **ArgoCD** vào cluster

Lab tập trung vào việc hiểu **đúng vai trò của Terraform**, **thứ tự triển khai (phase)** và **best practice DevOps**.

---

## 2. Kiến trúc tổng thể

Terraform
    |
    |-- Network (VPC, Subnet, Firewall)
    |-- Compute (VM master, VM worker)
    |-- RKE2 bootstrap (Kubernetes cluster)
    |-- Docker + Rancher (trên VM master)
    |
    Kubernetes (RKE2)
        |
        |-- Namespace argocd
        |-- ArgoCD

## 3


---

## 4. Nguyên tắc thiết kế

- **Variables tập trung** trong `variables.tf`
- `main.tf` chỉ đóng vai trò **orchestrator**
- Mỗi module có **trách nhiệm rõ ràng**
- **Không trộn infra và platform trong cùng một phase**
- Terraform dùng cho **Day-0 / Day-1**
- ArgoCD dùng cho **Day-2 (GitOps)**

---

## 5. Các phase triển khai

### Phase 1 – Infra + Cluster (Terraform)
Terraform thực hiện:
- Tạo VPC, Subnet, Firewall
- Tạo VM master và worker
- Cài RKE2 server / agent
- Cài Docker
- Chạy container Rancher trên VM master

Chạy:
    - terraform init
    - terraform apply

### Phase 2 – Kiểm tra cluster

SSH vào master:

- ssh pmt@<MASTER_PUBLIC_IP>


Kiểm tra RKE2:

- sudo /var/lib/rancher/rke2/bin/kubectl get nodes


Copy kubeconfig về máy local:

- scp pmt@<MASTER_PUBLIC_IP>:/etc/rancher/rke2/rke2.yaml ~/.kube/config

### Phase 3 – Platform (ArgoCD)

Sau khi:

RKE2 đã Ready

Rancher webhook đã chạy ổn định

Tạo namespace và cài ArgoCD:

kubectl create namespace argocd

kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 6. Những vấn đề đã gặp & bài học rút ra

Terraform không chờ service trong VM chạy xong

Không nên triển khai infra + platform trong cùng một terraform apply

Module có provider bên trong sẽ trở thành legacy module

Rancher webhook chưa sẵn sàng sẽ block Kubernetes API

Cần tách phase rõ ràng để hệ thống ổn định

# 7. Kết luận

Lab này giúp:

Hiểu rõ Terraform module architecture

Hiểu đúng vai trò của Terraform trong hệ sinh thái Kubernetes

Thực hành triển khai RKE2 + Rancher + ArgoCD theo đúng thứ tự

Tránh các lỗi kiến trúc thường gặp ở Junior/Mid DevOps

# 8. Hướng phát triển tiếp theo

Cài ArgoCD bằng Helm

Quản lý application theo GitOps

Thêm HA cho RKE2 master

Tích hợp CI/CD

Tách environment: dev / staging / prod