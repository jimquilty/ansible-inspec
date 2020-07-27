resource "aws_instance" "linux_nodes" {
  connection {
    host        = "${self.public_ip}"
    user        = "${var.aws_centos_image_user}"
    private_key = "${file("${var.aws_key_pair_file}")}"
  }

  count                       = "${var.linux_nodes_count}"
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
    Name          = "${var.tag_contact}-${var.tag_customer}-linux-${count.index + 1}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }

  provisioner "file" {
    content     = "VKca6ezRD0lfuwvhgeQLPSD0RMwE/ZYX5nYfGi2x0R1mXNh4QZSpa50H2deB85HoV/Ik48orF4p0/7MuVNPwNA=="
    destination = "/home/${var.aws_centos_image_user}/CTL_SECRET"
  }

  provisioner "file" {
    content     = "${data.template_file.ssh_public_key.rendered}"
    destination = "/home/${var.aws_centos_image_user}/id_rsa.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf /etc/machine-id",
      "sudo systemd-machine-id-setup",
      "sudo hostname comp-linux-${count.index + 1}",
      "sudo /sbin/sysctl -w net.ipv4.conf.all.accept_source_route=0",
      "sudo /sbin/sysctl -w net.ipv4.conf.default.accept_source_route=0",
      "sudo /sbin/sysctl -w net.ipv4.conf.default.accept_redirects=0",
      "sudo /sbin/sysctl -w net.ipv4.conf.all.accept_redirects=0",
      "cat /home/${var.aws_centos_image_user}/id_rsa.pub >> /home/${var.aws_centos_image_user}/.ssh/authorized_keys"
    ]
  }
}
