# 🚀 DevOps Intern – Ansible Lab Practice

> 💡 Repository này được tạo trong quá trình **thực tập DevOps**, nhằm mục tiêu học, hiểu và thực hành **Ansible** – công cụ tự động hóa cấu hình hệ thống.

---

## 🎯 Mục tiêu
- Nắm vững **kiến trúc hoạt động của Ansible** (Controller, Managed Node, Inventory, Playbook, Role).
- Thực hành các module cơ bản: `apt`, `service`, `copy`, `template`, `loop`, `handlers`.
- Từng bước **xây dựng pipeline tự động hóa Terraform → Ansible → Verify Cluster**.

---

## 📁 Cấu trúc thư mục

devops-intern-interspace/
│
├── ansible_quickstart/ # Bài thực hành cơ bản
│ ├── inventory.yaml
│ ├── playbook.yaml
│ ├── playbooktest.yaml
│
├── ansible_viblo/ # Bài thực hành nâng cao (theo hướng dẫn Viblo)
│ ├── apache.yaml # Cài đặt Apache2 và copy file HTML tĩnh
│ ├── part2_viblo.yaml # Cài đặt LAMP stack (Apache + MySQL + PHP)
│ ├── index.html # Template HTML có biến domain_name & index_file
│ ├── inventory.ini # Khai báo host nhóm gcp_tri
│
└── README.md # Tài liệu mô tả dự án (file hiện tại)

r
Sao chép mã

---

## ⚙️ Nội dung chi tiết

### 🧩 **1. Bài lab 1 – ansible_quickstart/**
- Làm quen với cấu trúc cơ bản của Ansible:
  - `inventory` để định nghĩa danh sách host.
  - `playbook` để mô tả các tác vụ tự động hóa.
- Các module đã sử dụng:
  - `apt`: cài đặt gói phần mềm.
  - `service`: khởi động và enable dịch vụ.
  - `copy`: sao chép file HTML tĩnh lên máy chủ.
- Cách chạy:
  ```bash
  ansible-playbook -i inventory.yaml playbook.yaml


🔧 2. Bài lab 2 – ansible_viblo/
🧠 File apache.yaml
yaml
Sao chép mã
- hosts: gcp_tri
  become: true
  tasks:
    - name: Cài Apache2
      apt:
        name: apache2
        state: present
        update_cache: yes

    - name: Khởi động Apache
      service:
        name: apache2
        state: started

    - name: Copy file index.html
      copy:
        src: ./index.html
        dest: /var/www/html/index.html
        
⚙️ File part2_viblo.yaml
Sử dụng vars và loop để cài đặt nhiều package.

Dùng template để render file HTML động.

Thêm notify/handlers để tự động restart service sau khi deploy.

yaml
Sao chép mã
- hosts: gcp_tri
  become: yes

  vars:
    domain_name: "gcp-demo.com"
    index_file: "index.html"

  tasks:
    - name: Install Apache and MySQL (Ubuntu)
      apt:
        name: "{{ item }}"
        state: present
      loop:
        - apache2
        - mysql-server
        - php
        - php-mysql

    - name: Deploy HTML file
      template:
        src: ./index.html
        dest: /var/www/html/index.html
      notify: restart web

  handlers:
    - name: restart web
      service:
        name: "{{ item }}"
        state: restarted
      loop:
        - apache2
        - mysql
🖥️ Template file index.html
html
Sao chép mã
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>{{ domain_name }}</title>
  </head>
  <body>
    <h1>Website của {{ domain_name }}</h1>
    <p>FILE_NAME: {{ index_file }}</p>
  </body>
</html>
🌐 Inventory
ini
Sao chép mã
[gcp_tri]
34.9.249.252
🧾 Kết quả
Cài đặt và cấu hình thành công Apache + MySQL + PHP trên VM GCP.

File HTML được deploy tự động với biến động (domain_name, index_file).

Sử dụng handlers giúp Ansible tự động restart service khi có thay đổi.

Tất cả bài lab đã được đẩy lên GitHub branch feature/ansible-lab.

🔜 Hướng phát triển tiếp theo
Chuẩn hóa thành Ansible Role (roles/web_server).

Kết nối Terraform output → Ansible input để tự động lấy IP node.

Tích hợp pipeline run.sh hoàn chỉnh:

nginx
Sao chép mã
Terraform → Ansible → Verify Cluster
👨‍💻 Tác giả
Phan Minh Trí – DevOps Intern
GitHub: phanminhtri667


BÀI TOÁN : 

thiết kế 1 quy trình devops !

provision  1 cụm k8s 
terraform dùng để làm gì ? -> tạo vpc, vm, network  ( input là gì ? output là gì ? (ip các vm))
ansible dùng để làm gì ? -> cấu hình cài đặt các phần mềm...(input là gì ?(output   từ   terraform ), output là gì ?.....)
Reverse proxy là gì ? ( upstrem, listen, ... -những cái quan trọng ?)

đặt vấn đề -> cách giải quyết -> vì sao lại dùng nó ???????