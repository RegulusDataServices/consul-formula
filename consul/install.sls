{% from "consul/map.jinja" import consul, consul_service with context %}

download_package:
  file.managed:
    - name: /tmp/consul.zip
    - source: {{ consul.consul_zip }}
    - source_hash: {{ consul.consul_zip_checksum }}

unzip_package:
  module.run:
    - name: archive.unzip
    - zip_file: /tmp/consul.zip
    - dest: /tmp/consul
    - require:
      - file: download_package

install_consul_bin:
  file.copy:
    - name: /usr/bin/consul
    - source: /tmp/consul/consul
    - require:
      - module: unzip_package

permission_consul_bin:
  file.managed:
    - name: /usr/bin/consul
    - mode: 0755

consul_config_directory:
  file.directory:
    - name: {{ consul.config_dir }}
    - makedirs: True

consul_data_directory:
  file.directory:
    - name: {{ consul.data_dir }}
    - makedirs: True

{% for name, contents in salt.pillar.get('consul:extra_configs', {}) %}
write_{{ name }}_config:
  file.managed:
    - name: {{ consul.config_dir }}/{{ name }}.json
    - contents: |
      {{ contents|json }}
    - require:
      - file: consul_config_directory
{% endfor %}

configure_consul_service:
  file.managed:
    - name: {{ consul_service.destination_path }}
    - source: salt://consul/templates/{{ consul_service.source_path }}
    - template: jinja
