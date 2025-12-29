# Terraform RKE2 Cluster on Google Cloud

## 1. Giới thiệu

Dự án này sử dụng **Terraform (Infrastructure as Code)** để tự động triển khai một **cụm Kubernetes RKE2** trên **Google Cloud Platform (GCP)**.

Hệ thống được thiết kế nhằm:
- Tạo hạ tầng mạng (VPC, Subnet, Firewall)
- Khởi tạo máy ảo cho **Master Node** và **Worker Node**
- Cài đặt và cấu hình **RKE2 (Rancher Kubernetes Engine 2)** hoàn toàn tự động bằng startup script

Phù hợp cho:
- Lab DevOps
- Học và thực hành Kubernetes
- Triển khai cụm RKE2 cơ bản trên GCP

---

## 2. Kiến trúc tổng quan

Hệ thống bao gồm:
- **1 VPC riêng**
- **1 Subnet**
- **Firewall** cho SSH và Kubernetes
- **Master Node (RKE2 Server)**
- **Worker Node (RKE2 Agent)**

Master chịu trách nhiệm quản lý cluster, Worker tham gia cluster thông qua token dùng chung.

---

## 3. Công nghệ sử dụng

- **Terraform >= 1.5**
- **Google Cloud Platform (Compute Engine)**
- **Ubuntu 22.04 LTS**
- **RKE2 (Kubernetes distribution của Rancher)**

---

## 4. Cấu trúc thư mục


lab-terraform-rke2/
├── provider.tf     # Khai báo provider và version Terraform
├── variables.tf    # Biến cấu hình (project, region, machine type, số node…)
├── main.tf         # Khai báo hạ tầng và cài đặt RKE2
└── outputs.tf      # Xuất IP public của các node


---

## 5. Chức năng chính

Tạo VPC và Subnet riêng biệt

Cấu hình Firewall cho:

SSH (22)

Kubernetes API (6443)

RKE2 communication (9345, 8472/UDP)

Tạo Master Node và tự động:

Cài đặt RKE2 Server

Khởi động Kubernetes Control Plane

Tạo Worker Node và tự động:

Cài đặt RKE2 Agent

Kết nối vào Master thông qua token

Xuất Public IP của Master và Worker sau khi deploy


---

## 6. Cách sử dụng
Bước 1: Chuẩn bị

Đã cấu hình gcloud auth

Có SSH key tại:

~/.ssh/id_ed25519.pub

Bước 2: Khởi tạo Terraform
terraform init

Bước 3: Kiểm tra kế hoạch
terraform plan

Bước 4: Triển khai hạ tầng
terraform apply


---

## 7. Kết quả sau khi triển khai

Một cụm Kubernetes RKE2 hoạt động trên GCP

Có thể SSH vào Master Node và sử dụng:

export PATH=$PATH:/var/lib/rancher/rke2/bin
kubectl get nodes