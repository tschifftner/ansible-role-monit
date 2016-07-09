# Ansible Role: Monit

[![Build Status](https://travis-ci.org/tschifftner/ansible-role-monit.svg)](https://travis-ci.org/tschifftner/ansible-role-monit)

Installs monit on Debian/Ubuntu linux servers.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    # Settings
    monit_interval: 60
    
    # Services
    monit_service_delete_unlisted: true

## Notfiy multiple adresses

To notify several addresses use ```monit_alert_addresses``` like:
```
monit_alert_addresses:
    - { address: 'test@email.com', cycle: 10 }
```

cycle defines the interval for reminders

## Dependencies

None.

## Example Playbook

    - hosts: server
      vars:
        monit_services:
          - name: ssh
            type: process
            target: /var/run/sshd.pid
            start: /usr/sbin/service ssh start
            stop: /usr/sbin/service ssh stop
            rules:
              - if failed port 22 protocol ssh then restart
              - if 5 restarts within 5 cycles then alert
    
          - name: syslog
            type: file
            target: /var/log/syslog
            rules:
              - if timestamp > 65 minutes then alert

      roles:
        - { role: tschifftner.monit }

## Ad-hoc commands
After checksum failing ansible can be used to restart monit
```
ansible webserver -a "service monit restart" --sudo
```
After restarting the failed service must be restored
```
ansible webserver -a "monit monitor exim4" --sudo
```

## License

MIT / BSD

## Author Information

 - [Tobias Schifftner](https://twitter.com/tschifftner), [ambimax® GmbH](https://www.ambimax.de)