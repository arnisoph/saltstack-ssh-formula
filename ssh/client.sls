#!jinja|yaml

{% from 'ssh/defaults.yaml' import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('ssh:lookup')) %}

ssh_client:
  pkg:
    - installed
    - pkgs: {{ datamap.client.pkgs }}

ssh_config:
  file:
    - managed
    - name: {{ datamap.client.config.ssh_config.path|default('/etc/ssh/ssh_config') }}
    - source: {{ datamap.client.config.ssh_config.template_path|default('salt://ssh/files/ssh_config') }}
    - template: {{ datamap.client.config.ssh_config.template_renderer|default('jinja') }}
    - mode: {{ datamap.client.config.ssh_config.mode|default(644) }}
    - user: {{ datamap.client.config.ssh_config.user|default('root') }}
    - group: {{ datamap.client.config.ssh_config.group|default('root') }}
