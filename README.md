# alike

This is is an attempt to reforge the final Alike Backup (A3) into the preview/unreleased Alike v7.5 that had been in use by beta-testers and partners.
The A3 host appliance is now available to built from sources (see below), instead of as a pre-built XVA download.

## Appliance Changes ##
This project is slightly different from the previous Alike / A3 product, which was delivered via an Alpine Linux virtual appliance that ran a debian Docker container that housed the Alike software.
This project's goal is to eliminate the Docker layer, and move the Alike software back to running directly on a Debian OS.  The benefits of this are both performance and simplicity, which in turn makes a much easier system to manage.


# Current Build Process #
At present, this project has only been tested on Debian 12.5, but it will likely work on other (modern) Debian based systems.
1. To make the new A3, you can use the Debian "preseed" process, by using the following URL as the script during an automated install.  Please be sure the sytem has at least 32GB of disk, and 1-2GB ram minimum.
http://tbd.com/a3.cfg
1. Once the base OS install is complete, login as root with the user "alike"  (Please change ASAP)
1. Then follow the steps presented on screen, which at present are:
  wget -O - https://place.com | bash
1. This will install the Alike software and services.
1. Add/configure your backup storage (ADS)
1. This can be a local disk, an NFS share, or any locally mounted storage at the mount point: /mnt/ads
1. You may now start the Alike services (from the menu), and proceed to the Web UI

# Final Thoughts #
If you are looking for the final update to the A3 product line, you can find a preserved docker image and the required docker-compose.yml file below.  This is here for archive purposes only, and will not be supported in this project.

## Docker-compose ###

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
