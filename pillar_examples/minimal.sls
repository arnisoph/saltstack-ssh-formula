ssh:
  lookup:
    server:
      config:
        sshd_config:
          template_path: False
    keyfiles:
      users:
        root: {}
        user_backup_keypair:
          name: root
          prvfile: /root/.ssh/id_rsa_backup
          pubfile: /root/.ssh/id_rsa_backup.pub
    userconfig:
      root:
        contents: |
          Host vcpmb1014.domain.de
            Port 64546
    auth:
      users:
        root:
          anykey:
            ensure: present
            enc: ssh-rsa
            comment: arnold@anyhost
            options:
              - command="echo 'Try again'"
            name: AAAAB3NzaC1yc2adamnlongstringhere
          foo:
            comment: arnold@anyhost
            name: AAAAB3Nzas1yc2EAAAADAQABAAAEAQC4YsdZy138T4agvtG2c2eyuJIT414noFEMkUhT8j6Jod4fLadamnlongstring
          bar:
            ensure: absent
            comment: arnold@anyhost
            name: AAAAB3NzaC1yc2EAAAADAQABAAAEAQC4YsdZy138T4agvtG2c2eyuJIT414noFEMkUhTtNj8j6JoLadamnlongstr1ng
