data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "master" {
  count         = var.master_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.master_instance
  subnet_id     = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name      = "devops-key"
  tags          = { Name = "rke2-master-${count.index}" }
}

resource "aws_instance" "worker" {
  count         = var.worker_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.worker_instance
  subnet_id     = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name      = "devops-key"
  tags          = { Name = "rke2-worker-${count.index}" }
}
