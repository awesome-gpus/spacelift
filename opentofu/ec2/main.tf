resource "aws_instance" "spacelift_instance" {
  ami                         = data.aws_ami.spacelift_server_ami.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnetId
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.aws_security_group_id]

  tags = {
    Name = "spacelift-node"
  }
}
