# alike

This is is an attempt to reforge the final Alike Backup (A3) into the preview/unreleased Alike v7.5 that had been in use by beta-testers and partners.
The A3 host appliance is now available to built from sources (see below), instead of as a pre-built XVA download.


Project for Alike Backup, a BDR solution for XenServer, XCP-ng, and Hyper-V virtualization platforms. 

## Xen Virtual Appliance (A3) Build steps
1. Download an [Alpine ISO](https://alpinelinux.org/downloads/) and boot your system with it.
2. Login with "root" to your Alpine system, then run "setup-alpine" and follow the prompts
	-Be sure to install Apline to your local disk (eg xvda and "sys" for Xen
3. Complete the setup and reboot, then login as root and run the following command: 
`wget -O- https://raw.githubusercontent.com/vtgreybeard/a3/main/bootstrap.sh | sh`

4. Once the reboot is complete, you may login as the "alike" user, and setup Alike as usual

## Docker-compose

If you know what you are doing, and are familiar with docker, you can use the following docker-compose.yml to make your own Alike container:
```yaml
volumes:
    cache-dbs:
    instaboot:
services:
    alike:
        container_name: alike
        image: alikebackup/a3
        stop_grace_period: 60s
        privileged: true
        init: true
        restart: always
        entrypoint: /a3init
        ports:
            - "80:80"
            - "443:443"
            - "445:445"
            - "222:22"
            - "111:111"
            - "2049:2049"
            - "2811:2811"
        tty: true
        volumes:
            - "/mnt/ads:/mnt/ads"
            - "/mnt/ods:/mnt/ods1"
            - "instaboot:/mnt/instaboot"
            - "./logs:/home/alike/logs"
            - "./certs:/home/alike/certs"
            - "./configs:/home/alike/configs"
            - "cache-dbs:/home/alike/Alike/remoteDBs"
        tmpfs:
            - /home/alike/Alike/temp:uid=1000,gid=33
            - /home/alike/Alike/DBs:uid=1000,gid=1000,exec
            - /run:uid=1000,gid=33
        networks:
            - alike-net
        cap_add:
            - NET_ADMIN
            - SYS_ADMIN
        environment:
            - HOST_BLD=${HOST_BLD:?Please check your /home/alike/.env file}
            - HOST_IP=${HOST_IP:?Please check your /home/alike/.env file}
networks:             
    alike-net:         
        driver: bridge 

```
