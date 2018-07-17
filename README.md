# Ansible Role: Monit

[![Build Status](https://travis-ci.org/tschifftner/ansible-role-monit.svg?branch=master)](https://travis-ci.org/tschifftner/ansible-role-monit)

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

## Configure SSL

Add certificate and certificate key to

```
monit_ssl_certificate: ''
monit_ssl_certificate_key: ''
```

## Dependencies

None.

# Included tests
This playbook comes with a lot of tests for standard software and is enabled automatically when found on server:

- amavisd-milter
- amavisd-new
- automysqlbackup
- crontab
- dovecot
- exim4
- fail2ban
- filesystem
- firewall
- firewall-ipv6
- hetzner-heartbeat (restarts external server when ping fails)
- hetzner-storagebox (check free space)
- mariadb
- munin-node
- nginx
- ntp
- opendkim
- php5-fpm
- php7-fpm
- postfix
- softraid
- solr
- ssh
- sslcertcheck (checks ssl certs and informs on problems)

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
ansible all -a "service monit restart" --become
```

After restarting the failed service must be restored

```
ansible all -a "monit monitor exim4" --become
```

### Test hetzner heartbeat

```
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j DROP
```

## Supported OS

 - Debian 9 (Stretch)
 - Debian 8 (Jessie)
 - Ubuntu 18.04 (Bionic Beaver)
 - Ubuntu 16.04 (Xenial Xerus)
 
## Required ansible version

Ansible 2.5+

## License

[MIT License](http://choosealicense.com/licenses/mit/)

## Author Information

 - [Tobias Schifftner](https://twitter.com/tschifftner), [ambimax® GmbH](https://www.ambimax.de)