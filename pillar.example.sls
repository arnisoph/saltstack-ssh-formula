ssh:
  lookup:
    client:
      config:
        ssh_config:
          template_path: False
    server:
      config:
        sshd_config:
          template_path: False
  keys:
    manage:
      users:
        root: {}
    auth:
      - user: root
        ensure: present
        enc: ssh-rsa
        comment: arnold@anyhost
        options:
          - command="echo 'Try again'"
        name: AAAAB3NzaC1yc2adamnlongstringhere
      - user: root
        comment: arnold@anyhost
        name: AAAAB3Nzas1yc2EAAAADAQABAAAEAQC4YsdZy138T4agvtG2c2eyuJIT414noFEMkUhT8j6Jod4fLadamnlongstring
      - user: root
        ensure: absent
        comment: arnold@anyhost
        name: AAAAB3NzaC1yc2EAAAADAQABAAAEAQC4YsdZy138T4agvtG2c2eyuJIT414noFEMkUhTtNj8j6JoLadamnlongstring
