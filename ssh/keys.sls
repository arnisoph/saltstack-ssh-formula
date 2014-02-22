{% from "ssh/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('ssh:lookup')) %}

{% for a in salt['pillar.get']('ssh:keys:auth') %}
ssh-auth-{{ a['user']|default('root') }}-{{ a['name'][-20:] }}:
  ssh_auth:
    - {{ a['ensure']|default('present') }}
    - name: {{ a['name'] }}
    - user: {{ a['user']|default('root') }}
    - enc: {{ a['enc']|default('ssh-rsa') }}
    - comment: {{ a['comment']|default('') }}
  {% if 'options' in a %}
    - options:
    {% for o in a['options']|default([]) %}
      - {{ o }}
    {% endfor %}
  {% endif %}
{% endfor %}

{# TODO: manage known hosts #}
