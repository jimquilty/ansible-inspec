data "template_file" "install_hab" {
  template = "${file("${path.module}/../templates/install-hab.sh")}"

  vars = {
    opts = "${var.hab_install_opts}"
  }
}

data "template_file" "flask_listener" {
  template = "${file("${path.module}/../templates/weblistener.py")}"

    vars = {
    os_user = "${var.aws_centos_image_user}"
  }
}

data "template_file" "weblistener_service" {
  template = "${file("${path.module}/../templates/weblistener.service")}"

  vars = {
    os_user = "${var.aws_centos_image_user}"
  }
}

data "template_file" "automate_eas_config" {
  template = "${file("${path.module}/../templates/automate-eas-config.toml.tpl")}"

  vars = {
    disable_event_tls = "${var.disable_event_tls}"
  }
} 