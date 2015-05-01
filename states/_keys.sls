#!jinja|yaml

{% set datamap = salt['formhelper.defaults']('ssh', saltenv) %}

{% for user, keymap in datamap.auth.users|default({})|dictsort %}
  {% for k, v in keymap|default({})|dictsort %}
ssh_auth_{{ keymap.user|default(user) }}_{{ v.name[-20:] }}:
  ssh_auth:
    - {{ v.ensure|default('present') }}
    - name: {{ v.name }}
    - user: {{ keymap.user|default(user) }}
    - enc: {{ v.enc|default('ssh-rsa') }}
    - comment: {{ v.comment|default('') }}
    {% if 'options' in v %}
    - options:
      {% for o in v.options|default([]) %}
      - {{ o }}
      {% endfor %}
    {% endif %}
  {% endfor %}
{% endfor %}

{% for user, config in datamap.userconfig|default({})|dictsort %}
ssh_clientconfig_{{ config.user|default(user) }}:
  file:
    - {{ config.ensure|default('managed') }}
    - name: {{ config.name|default(salt['user.info'](user).home ~ '/.ssh/config') }}
    - user: {{ config.user|default(user) }}
    - group: {{ config.group|default(user) }}
    - mode: {{ config.mode|default(600) }}
  {% if 'contents' in config %}
    - contents_pillar: ssh:lookup:userconfig:{{ user }}:contents
  {% endif %}
{% endfor %}

{% for id, host in datamap.known_hosts|default({})|dictsort %}
ssh_known_host_{{ host.name }}:
  ssh_known_hosts:
    - {{ host.ensure|default('present') }}
    - name: {{ host.name }}
    - user: {{ host.user|default('root') }}
    - port: {{ host.port|default(22) }}
    - hash_hostname: {{ host.hash_hostname|default(True) }}
  {% if 'enc' in host %}
    - enc: {{ host.enc }}
  {% endif %}
  {% if 'config' in host %}
    - config: {{ host.config }}
  {% endif %}
  {% if 'fingerprint' in host %}
    - fingerprint: {{ host.fingerprint }}
  {% endif %}
{% endfor %}

{% for k, v in datamap.keyfiles.users|default({})|dictsort %}
  {% set user = v.name|default(k) %}
  {% set prvfile = v.prvfile|default(salt['user.info'](user).home ~ '/.ssh/id_rsa') %}
  {% set pubfile = v.pubfile|default(salt['user.info'](user).home ~ '/.ssh/id_rsa.pub') %}

  {% if salt['file.file_exists'](pubfile) == False %}
managekeypair_{{ user }}_{{ prvfile }}:
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
