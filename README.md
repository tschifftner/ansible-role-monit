# Ansible Role: Monit

[![Build Status](https://travis-ci.org/tschifftner/ansible-role-monit.svg)](https://travis-ci.org/tschifftner/ansible-role-monit)

Installs monit on Debian/Ubuntu linux servers.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    nginx_package: nginx-full

## Dependencies

None.

## Example Playbook

    - hosts: server
      roles:
        - { role: tschifftner.monit }

## License

MIT / BSD

## Author Information

 - Tobias Schifftner, @tschifftner