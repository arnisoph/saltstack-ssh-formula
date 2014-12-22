#!jinja|yaml

{% from 'ssh/defaults.yaml' import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('ssh:lookup')) %}

{% for a in salt['pillar.get']('ssh:keys:auth', []) %}
ssh_auth_{{ a.user|default('root') }}_{{ a.name[-20:] }}:
  ssh_auth:
    - {{ a.ensure|default('present') }}
    - name: {{ a.name }}
    - user: {{ a.user|default('root') }}
    - enc: {{ a.enc|default('ssh-rsa') }}
    - comment: {{ a.comment|default('') }}
  {% if 'options' in a %}
    - options:
    {% for o in a.options|default([]) %}
      - {{ o }}
    {% endfor %}
  {% endif %}
{% endfor %}

{% for k, v in salt['pillar.get']('ssh:keys:manage:users', {})|dictsort %}
  {% set user = v.name|default(k) %}
  {% set prvfile = v.prvfile|default(salt['user.info'](user).home ~ '/.ssh/id_rsa') %}
  {% set pubfile = v.pubfile|default(salt['user.info'](user).home ~ '/.ssh/id_rsa.pub') %}

  {% if salt['file.file_exists'](pubfile) == False %}
managekeypair_{{ user }}:
  cmd:
    - run
    - name: /usr/bin/ssh-keygen -q -b {{ v.keysize|default(8192) }} -t rsa -f {{ prvfile }} -N '' -C ''
    - user: {{ user }}
  {% endif %}
{% endfor %}

{% set hpk = datamap.client.hostspubkey|default({}) %}

{% if hpk.collect|default(False) %}
  {% for k, v in salt['publish.publish'](hpk.tgt|default('*'), hpk.fun|default('grains.get'), hpk.arg|default('fqdn'), hpk.exprform|default('glob')).items() if v|length > 0 %}
hostpubkey_{{ k }}:
  ssh_known_hosts:
    - present
    - name: {{ v }}
    - port: {{ salt['pillar.get']('ssh:client:settings:port', 22) }}
    - enc: ssh-rsa
    - hash_hostname: False
  {% endfor %}
{% endif %}
