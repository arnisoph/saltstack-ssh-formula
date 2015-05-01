#!jinja|yaml

{% set datamap = salt['formhelper.defaults']('ssh', saltenv) %}

# SLS includes/ excludes
include: {{ datamap.server.sls_include|default([]) }}
extend: {{ datamap.server.sls_extend|default({}) }}

ssh_server:
  pkg:
    - installed
    - pkgs: {{ datamap.server.pkgs }}
  service:
    - running
    - name: {{ datamap.server.service.name }}
    - enable: {{ datamap.server.service.enable|default(True) }}

{% for c in datamap.server.config.manage %}
  {% set f = datamap['server']['config'][c]|default({}) %}
ssh_server_{{ c }}:
  file:
    - managed
    - name: {{ f.path }}
    - source: {{ f.template_path|default('salt://ssh/files/ssh_config') }}
    - template: {{ f.template_renderer|default('jinja') }}
    - user: {{ f.user|default('root') }}
    - group: {{ f.group|default('root') }}
    - mode: {{ f.mode|default(644) }}
    - watch_in:
      - service: ssh_server
{% endfor %}
