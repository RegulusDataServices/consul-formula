{% from "consul/map.jinja" import consul with context %}

install_consul:
  file.managed:
    - name: /tmp/consul.zip
    - source: https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip
