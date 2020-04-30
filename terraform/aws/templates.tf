data "template_file" "install_hab" {
  template = "${file("${path.module}/../templates/install-hab.sh")}"

  vars = {
    opts = "${var.hab_install_opts}"
  }
}

data "template_file" "sup_service" {
  template = "${file("${path.module}/../templates/hab-sup.service")}"

  vars = {
    stream_env = "${var.event-stream-enabled == "true" ? var.event-stream-env-var : ""}"
    flags = "${var.event-stream-enabled == "true" ? "--auto-update --peer ${aws_instance.windows_workstation.private_ip} --listen-gossip 0.0.0.0:9638 --listen-http 0.0.0.0:9631 --listen-ctl 0.0.0.0:9632 --event-stream-application=${var.event-stream-application} --event-stream-environment=${var.event-stream-environment} --event-stream-site=${var.aws_region} --event-stream-url=${aws_instance.chef_automate.public_ip}:4222 --event-stream-token=${data.external.a2_secrets.result["a2_token"]}" : "--auto-update --peer ${aws_instance.windows_workstation.private_ip} --listen-gossip 0.0.0.0:9638 --listen-http 0.0.0.0:9631 --listen-ctl 0.0.0.0:9632" }"
  }
}

data "template_file" "automate_eas_config" {
  template = "${file("${path.module}/../templates/automate-eas-config.toml.tpl")}"

  vars = {
    disable_event_tls = "${var.disable_event_tls}"
  }
} 