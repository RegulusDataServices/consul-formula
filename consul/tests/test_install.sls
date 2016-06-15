test_consul_instaled:
  testinfra.file:
    - exists: True
