{% from "consul/map.jinja" import consul with context %}

install_consul:
  file.managed:
    - name: /tmp/consul.zip
    - source: {{ consul.consul_zip }}
    - source_hash: {{ consul.consul_zip_checksum }}

unzip_consul:
  module.run:
    - name: unzip
    - kwargs:
      - zip_file: /tmp/consul.zip
      - dest: /tmp/consul
