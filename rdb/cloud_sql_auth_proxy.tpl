#cloud-config

users:
- name: cloudservice
  uid: 2000

write_files:
- path: /etc/systemd/system/cloudservice.service
  permissions: 0644
  owner: root
  content: |
    [Unit]
    Description=Start Cloud SQL Auth Proxy docker container

    [Service]
    ExecStart=/usr/bin/docker run --rm -u 2000 --name=${container_name} -p 127.0.0.1:5432:5432 ${cloud_sql_auth_proxy_image_tag} --address 0.0.0.0 --port 5432 --psc ${cloud_sql_dns_name}
    ExecStop=/usr/bin/docker stop ${container_name}
    ExecStopPost=/usr/bin/docker rm ${container_name}

runcmd:
- systemctl daemon-reload
- systemctl start cloudservice.service
