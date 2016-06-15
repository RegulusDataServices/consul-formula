{% from "consul/map.jinja" import consul with context %}

test_consul_installed:
  testinfra.file:
    - name: /usr/bin/consul
    - exists: True

{% for dir in [consul.data_dir, consul.config_dir] %}
test_{{ dir }}_dir_exists:
  testinfra.file:
    is_directory: True
{% endfor %}
