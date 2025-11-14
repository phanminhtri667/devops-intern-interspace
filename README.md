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



-----------------------
ok bây giờ  tôi sẽ trình bày lại   nhưng gì tôi đã hiểu về ansible bạn hãy đọc và nhận xét cách hiểu của tôi đã đúng và đầy đủ chưa nhé !
----
1.  Ansible là  1  công cụ mã nguồn mở  để tự động hóa  quản lý cấu hình , triển khai ứng dụng, cung cấp hạ tầng được phát triển bởi red Hat  với kiến trúc agenless  kết nối  bằng SSH hoặc API  mà không cần  agent nào khác ( phần mềm thứ 3 )
2. khi thực hiện  tạo  máy ảo, vpc,... trên các  platform : aws, gcp .....  thì khi cấu hình bằng tay trên giao diện   sẽ chậm  và mất nhiều thời gian  khi tạo trên nhiều  platform mà các cấu hình  cũng sẽ  dễ  bị conflict ,......  do đó  ansible  sẽ giúp cải thiện vấn đề đó , nó  có thể tạo  cấu hình, cài đặt  hạt loạt trên các  nền tảng  ,  cấu hình cài đặt  được định nghĩa trong file yaml - thuận  tiện sửa chữa tái sử dụng, triển khai 1 cách đồng bộ  trên các server , tự động lặp lại các task trên server và triển khai theo thứ tự . một điểm làm ansible nổi bật hơn các công cụ khác như là : Chef, Puppet, hoặc SaltSta  đó là  sử dụng agentLess để kết nối tới  server  mà không cần agent nào khác

3. các thành phần chính   để thực thi  ansible :
+ inventory : là 1 file  lưu thông tin để kết nối  đến các host
+ playbooks : là 1 file  yaml gồm nhiều play , file này giúp định nghĩa các công việc   cần làm trên 1 hoặc nhiều host. file này chứa các thông tin : tên host cần làm việc , các công việc cần làm trên  host đó . khi chạy lệnh ansible-playbook thì nó sẽ đọc  lần lượt từ trên xuống  đọc tên host - đã được định nghĩa ở file inventory  sau đó kết nối  vào host đó và thực nhiện các task  đã được khai báo.
+ play  là 1  đoạn code đã được khai báo để  làm việc nào đó  trên 1 host trong file playbooks
+ task là  1 phần để khai báo các công việc cần làm trong plays , 1 task có nhiều việc làm gọi là task list
+ module là 1 chức năng được ansible  định nghĩa sẵn  dùng để làm các tác vụ với 1 đối số  mà người dùng khai báo mong muốn trong task đó làm . ví dụ muốn  xem ip  thì dùng mudule : command và  đối số  cmd : ip a  - tác dụng khi  thực hiện 1 task này là  mudule  này là  command sẽ  vào terminal  chạy đối số cmd với lệnh ip a để xem địa chỉ ip 
+ role là 1 cấu trúc  tổ chức playbook theo thư mục, giúp dễ quản lý, tái sử dụng . 
+ varibles :  là 1 file , biến  để định nghĩa các  biến  dùng ở nhiều nơi mà khi cần sửa  thì  chỉ cần sửa đúng 1 chỗ hoặc 1 biến từ 1 ouput nào đó mình chưa biết được kết quả thì sẽ gán nó vào biến .varibles giúp dễ sửa chữa và tái sử dụng
+ Handler : là 1 tác vụ chỉ chạy khi  có sự thay đổi , ví dụ :  1 task có notify là abc  khi web này được thay đổi nội dung thì  handler abc sẽ phát hiện và chạy các cong việc được định nghĩa ( hãy cho 1 ví dụ thực tế của phần này dễ hiểu )
+ loop : là vòng lặp  để chạy 1 task nhiều lần với  nhiều giá trị .
+ fact : là thông tin được thu thập từ máy đích : OS, IP , ram ,....  dùng làm điều  kiện để thực thi 1 task ví dụ : cài nginx khi máy đó là ubuntu.
+ ansible vault : là  cơ chế mã hóa  dữ liệu nhạy cảm  như  mật khẩu , API key giúp bảo mật thông tin .
+ template là 1 module của ansible để chèn biến , điều kiện , vòng lặp và logic trước khi khi gửi lên máy đích giúp tùy biến theo từng server mà chỉ cần 1 mẫu template duy nhất . ví dụ : khi cài nginx thì sẽ tạo 1 file .j2 và có 1 biến để truyền vào name-server . khi chạy playbook sẽ tùy biến truyền tên server vào template này giúp nhanh gọn chỉ cần thay thế biến là có thể cài nginx cho server muốn cài .

4 . ansible hoạt động  :
+ người dùng tạo playbook  và chạy từ controller machine  nơi cài đặt ansible 
+ khi chạy command để thực thi playbook   , command line này sẽ đọc toàn bộ file cấu hình playbook tuần tự từ trên xuống dưới 
+ playbook gọi tới inventory  để xác định máy chủ và acces vào thực hiện các task 
+ Ansible Automation Engine  sử lý playbook đọc từng task  gọi các module  sử dụng api và plugin để thực thi
+ ansible kết nối ssh tới  các host  thực hiện task thu thập kết quả 
+ nếu có thay đổi handler  thực hiện và restart lại 
+ cuối cùng ansible  tổng hợp  task change , ok , failed 

5 . tổng kết  :
- ansible  sử dụng yaml  dể đọc dễ sử dụng thực hiện tuần tự từ trên xuống 
- agentless  không cần agent khác để thực thi
- xử lý mạnh mẽ, nhiều module có sẵn 
- dễ mở rộng tích hợp với  terraform, jenkins  , ...
- cộng đồng lớn  dễ support nhau 
-> ansible  giúp tự động hóa  cấu hình cài đặt ứng dụng , giảm lỗi con người , hiệu suất  hàng loạt , không cần agent .

