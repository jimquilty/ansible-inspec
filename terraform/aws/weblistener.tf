resource "aws_instance" "linux_weblistener" {
  connection {
    host        = "${self.public_ip}"
    user        = "${var.aws_centos_image_user}"
    private_key = "${file("${var.aws_key_pair_file}")}"
  }

  ami                         = "${data.aws_ami.centos7.id}"
  instance_type               = "t2.medium"
  key_name                    = "${var.aws_key_pair_name}"
  subnet_id                   = "${aws_subnet.habmgmt-subnet-a.id}"
  vpc_security_group_ids      = ["${aws_security_group.chef_automate.id}"]
  associate_public_ip_address = true

  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }

  tags = {
    Name          = "${var.tag_contact}-${var.tag_customer}-linux-weblistener"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }

  provisioner "file" {
    content     = "${data.template_file.flask_listener.rendered}"
    destination = "/home/${var.aws_centos_image_user}/weblistener.py"
  }

  provisioner "file" {
    content     = "${data.template_file.weblistener_service.rendered}"
    destination = "/home/${var.aws_centos_image_user}/weblistener.service"
  }

  provisioner "file" {
    content     = "${data.template_file.ansible_playbook.rendered}"
    destination = "/home/${var.aws_centos_image_user}/httpd.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf /etc/machine-id",
      "sudo systemd-machine-id-setup",
      "sudo hostname linux-weblistener",
      "sudo /sbin/sysctl -w net.ipv4.conf.all.accept_source_route=0",
      "sudo /sbin/sysctl -w net.ipv4.conf.default.accept_source_route=0",
      "sudo /sbin/sysctl -w net.ipv4.conf.default.accept_redirects=0",
      "sudo /sbin/sysctl -w net.ipv4.conf.all.accept_redirects=0",
      "sudo yum install python3 -y",
      "sudo pip3 install flask",
      "sudo pip3 install ansible",
      "chmod +x /home/${var.aws_centos_image_user}/weblistener.py",
      "mkdir /home/${var.aws_centos_image_user}/playbooks",
      "mv /home/${var.aws_centos_image_user}/httpd.yml /home/${var.aws_centos_image_user}/playbooks/httpd.yml",
      "sudo mv /home/${var.aws_centos_image_user}/weblistener.service /etc/systemd/system/weblistener.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl start weblistener",
      "sudo systemctl enable weblistener"
    ]
  }
}