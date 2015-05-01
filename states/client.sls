#!jinja|yaml

{% set datamap = salt['formhelper.defaults']('ssh', saltenv) %}

# SLS includes/ excludes
include: {{ datamap.client.sls_include|default([]) }}
extend: {{ datamap.client.sls_extend|default({}) }}

ssh_client:
  pkg:
    - installed
    - pkgs: {{ datamap.client.pkgs }}

{% for c in datamap.client.config.manage %}
  {% set f = datamap['client']['config'][c]|default({}) %}
ssh_client_{{ c }}:
  file:
    - managed
    - name: {{ f.path }}
    - source: {{ f.template_path|default('salt://ssh/files/ssh_config') }}
    - template: {{ f.template_renderer|default('jinja') }}
    - user: {{ f.user|default('root') }}
    - group: {{ f.group|default('root') }}
    - mode: {{ f.mode|default(644) }}
{% endfor %}
