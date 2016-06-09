{% from "consul/map.jinja" import consul with context %}

consul_config_directory:
  file.directory:
    - name: {{ consul.config_dir }}
    - makedirs: True

configure_consul_service:
  file.managed:
    - name: {{ consul_service.destination_path }}
    - source: salt://consul/templates/{{ consul_service.source_path }}
    - template: jinja

{% for name, contents in salt.pillar.get('consul:extra_configs', {}) %}
write_{{ name }}_config:
  file.managed:
    - name: {{ consul.config_dir }}/{{ name }}.json
    - contents: |
      {{ contents|json }}
    - require:
      - file: consul_config_directory
    - require_in:
      - start_consul_service
    - watch_in:
      - start_consul_service
{% endfor %}
