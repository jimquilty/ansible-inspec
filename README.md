# Inspec + Ansible + Redmediation
This repo lets you demonstrate test driven development with Inspec, Ansible and Test Kitchen and show a way to remediate Inspec identified issues with Automate and Ansible.

## Requirements
### Test Driven Development
- [Chef Workstation](https://downloads.chef.io)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- Kitchen Ansible Gem: ```chef gem install kitchen-ansible```
### Inspec + Ansible using Automate
- [Chef Workstation](https://downloads.chef.io)
- [Terraform](https://terraform.io)
- AWS Account in the Chef SA Organization (for SSL certificates)
- [Okta_AWS CLI Tool](https://github.com/chef/okta_aws)
- Automate 2 License
- Private/Public SSH Key Pair

## Test Driven Development
The kitchen.yml file will spin up a vagrant instance of centos and configure it using Ansible. The site.yml file will be applied. The site_verify test will check for several httpd requirements.
Comment out a portion of the site.yml file prior to running a ```kitchen converge``` to show test failure with Inspec.

## Inspec + Ansible using Automate
