# 🌍 Terraform Learning Day — GCP Labs Summary

## 📅 Ngày thực hiện
**29/10/2025**

## 🎯 Mục tiêu
Tiếp tục chuỗi học và thực hành **Terraform trên Google Cloud Platform (GCP)** theo tài liệu chính thức của HashiCorp, nhằm hiểu rõ nguyên lý hoạt động, cấu trúc file và vòng đời tài nguyên trong IaC (Infrastructure as Code).

---

## 🧱 Nội dung đã thực hiện

### 🧩 1. Khởi tạo Terraform & Provider Google Cloud
- Cấu hình **provider "google"** và khởi tạo project GCP.
- Tạo thành công **VPC network**, **subnet**, và **VM instance đầu tiên** bằng Terraform.

### 📦 2. Quản lý State File (`terraform.tfstate`)
- Hiểu cơ chế lưu trữ trạng thái tài nguyên.
- Biết cách Terraform theo dõi sự thay đổi (create → modify → destroy).
- Kiểm tra file `.tfstate` để xác định tài nguyên đang được quản lý.

### 💣 3. Destroy Infrastructure
- Thực hành `terraform destroy` để xóa tài nguyên khỏi GCP.
- Hiểu rõ vòng đời hạ tầng và tầm quan trọng của việc kiểm soát xóa tài nguyên an toàn.

### ⚙️ 4. Biến & File cấu hình (`variables.tf`, `terraform.tfvars`)
- Sử dụng biến để làm cấu hình linh hoạt hơn.
- Dễ dàng tái sử dụng cùng cấu trúc cho **multi-cloud** hoặc nhiều môi trường (dev/test/prod).

### 📤 5. Outputs (`outputs.tf`)
- Định nghĩa output để lấy giá trị sau khi triển khai (VD: IP nội bộ của VM).
- Thực hành lệnh:
  ```bash
  terraform output


✅ Kết quả đạt được

Tạo thành công hạ tầng GCP (VPC + VM instance) qua Terraform nhiều lần.

Hiểu rõ quy trình Terraform → Plan → Apply → Destroy.

Sử dụng thành thạo các file cấu trúc chuẩn:

main.tf
variables.tf
terraform.tfvars
outputs.tf


Hiểu và thao tác được với state file, output values, provider Google, terraform apply/destroy.

Hoàn thành chuỗi hướng dẫn “Terraform Getting Started on GCP” từ tài liệu HashiCorp.

🔗 Tài liệu tham khảo

Terraform Official Docs — GCP Get Started

Terraform Registry: Google Provider: