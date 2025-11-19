📘 README – Tổng hợp Labs 1 → 6 (Terraform + Ansible)
🎯 1. Vấn đề gặp phải

Khi làm việc với Google Cloud Platform (GCP), tôi gặp nhiều khó khăn:

Mỗi lần tạo VM, VPC, subnet… tôi phải mở GCP Console và click chuột thủ công, rất mất thời gian.

Dễ cấu hình sai vì làm nhiều bước manual.

Khi GCP bị khóa tài khoản, tôi phải tạo lại tài nguyên từ đầu, không có chuẩn hoá.

Không có cách tự động cấu hình máy (nginx, docker, app…) sau khi tạo VM.

Muốn tất cả hạ tầng + cấu hình đều phải được mô tả bằng code (Infrastructure as Code + Configuration as Code).

Do đó, tôi xây dựng chuỗi LAB 1 → 6 để giải quyết toàn bộ những vấn đề trên.

🧪 2. Các LAB từ 1 → 6
✅ LAB 1 – Terraform Basic
✔ Mục tiêu

Làm quen với Terraform cơ bản.

Tạo hạ tầng bằng 1 file main.tf.

Biến số tập trung ở variables.tf.

Xuất thông tin bằng outputs.tf.

✔ Giải quyết vấn đề:

Không cần click GCP Console để tạo VM/VPC.

Chuyển sang làm việc theo IaC.

✔ Sử dụng:

Terraform (provider Google).

main.tf, variables.tf, outputs.tf.

➡ Chỉ cần nhìn vào variables.tf là biết hạ tầng gồm những gì → dễ hiểu, dễ sửa, dễ tái sử dụng.

✅ LAB 2 – Terraform Modules (tối ưu IaC)
✔ Mục tiêu

Chia resource thành module riêng: vpc, subnet, vm, firewall.

Module hoá giúp tái sử dụng nhiều dự án khác nhau.

Người mới chỉ cần chỉnh file variables.tf.

✔ Giải quyết vấn đề:

Tái sử dụng hạ tầng → "Design Once, Use Everywhere".

Clean code, maintain dễ, chuẩn DevOps.

Chuẩn hoá cấu trúc Terraform.

✔ Sử dụng:

Terraform with modules.

Module: vpc, subnet, vm, firewall.

✅ LAB 3 – Ansible Basic
✔ Mục tiêu

SSH tự động vào VM tạo bằng Terraform.

Thực hiện các task cơ bản:

ping

cài htop

tạo file hello.txt

✔ Giải quyết vấn đề:

Không cần SSH thủ công vào từng VM.

Tự động cấu hình môi trường.

✔ Sử dụng:

Ansible inventory

playbook.yml

✅ LAB 4 – Ansible Roles
✔ Mục tiêu

Tổ chức code Ansible thành Role chuyên nghiệp.

Tạo các role cơ bản: common, network-tools, editors.

✔ Giải quyết vấn đề:

Chuẩn hoá cấu hình server.

Code dễ mở rộng cho team DevOps.

Mỗi role xử lý 1 chức năng → tái sử dụng tốt.

✔ Sử dụng:

Ansible roles

Nhiều task nâng cao để cài editor, net-tools, ping, telnet…

✅ LAB 5 – Terraform + Ansible Integration (Basic)
✔ Mục tiêu

Terraform tạo VM.

Terraform xuất public IP của VM qua outputs.

Ansible tự đọc output đó → tự tạo inventory.

SSH vào VM để cài Apache và deploy file HTML đơn giản.

✔ Giải quyết vấn đề:

Tự động kết nối Terraform ↔ Ansible.

Không cần tự viết hoặc sửa inventory.

Dễ dàng triển khai cấu hình sau khi tạo VM.

✔ Sử dụng:

Terraform output

Script generate_inventory.sh

Ansible playbook cài Apache

🔍 Phân tích thêm: các CÁCH khác để Ansible nhận output Terraform làm inventory

Script generate_inventory.sh (đang dùng)

Đọc Terraform output

Tự động ghi inventory.ini

Cách đơn giản nhất cho người mới.

Dùng lookup trong inventory (không cần script)

ansible_host={{ lookup('pipe', 'terraform -chdir=../terraform output -raw vm_public_ip') }}


Ansible tự đọc output mỗi lần chạy playbook.

Terraform → chạy Ansible bằng local-exec

Không cần inventory file.

Terraform truyền IP inline:

ansible-playbook -i '34.55.11.23,' playbook.yml


Dynamic Inventory Plugin – đọc terraform.tfstate

Không cần output.

Ansible tự parse state file:

plugin: community.general.terraform_state
state_file: ../terraform/terraform.tfstate


Terraform remote backend + Ansible dynamic inventory

Đọc state từ GCS / S3

Dùng trong môi trường production / multi-env.

➡ LAB5 thực hành Cách 1, nhưng bạn đã hiểu toàn bộ hệ sinh thái.

🟦 LAB 6 – Terraform + Ansible PRO (Full Automation)
✔ Mục tiêu

Tự động hoá quy trình DevOps thực chiến:

Terraform tạo full hạ tầng:

VPC / Subnet

VM web

VM database

Terraform export IP web + db

Terraform tự chạy Ansible bằng local-exec (không cần chạy Ansible bằng tay)

Ansible roles:

webserver → Nginx + Docker + NodeJS

database → MySQL + tạo DB + user

deploy NodeJS app → web hoạt động ngay

✔ Giải quyết vấn đề:

Full automation: Provisioning + Configuration

Tạo toàn bộ hệ thống chỉ bằng 1 lệnh:

terraform apply -auto-approve


Không cần:

click GCP

SSH

Sửa file config

Viết inventory

✔ Sử dụng:

Terraform modules + outputs

Ansible roles

local-exec provisioner

Docker, NodeJS, Nginx, MySQL

🚀 3. Tổng Kết
LAB	Nội dung	Công cụ
LAB1	Terraform Basic	Terraform (main/vars/output)
LAB2	Terraform Modules	Terraform Modules
LAB3	Ansible Basic	Ansible Playbook
LAB4	Ansible Roles	Ansible Roles
LAB5	Terraform ↔ Ansible Basic Integration	Terraform output, inventory auto
LAB6	Terraform ↔ Ansible PRO Automation	Terraform + Ansible + Roles + Docker + Nginx