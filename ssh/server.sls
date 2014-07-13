#!jinja|yaml

{% from "ssh/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('ssh:lookup')) %}

ssh_server:
  pkg:
    - installed
    - pkgs: {{ datamap.server.pkgs }}
  service:
    - running
    - name: {{ datamap.server.service.name }}
    - enable: {{ datamap.server.service.enable|default(True) }}
    - watch:
      - file: sshd_config
    - require:
      - pkg: ssh_server

sshd_config:
  file:
    - managed
    - name: {{ datamap.server.config.sshd_config.path|default('/etc/ssh/sshd_config') }}
    - source: {{ datamap.server.config.sshd_config.template_path|default('salt://ssh/files/sshd_config') }}
    - template: {{ datamap.server.config.sshd_config.template_renderer|default('jinja') }}
    - mode: {{ datamap.server.config.sshd_config.mode|default(644) }}
    - user: {{ datamap.server.config.sshd_config.user|default('root') }}
    - group: {{ datamap.server.config.sshd_config.group|default('root') }}
