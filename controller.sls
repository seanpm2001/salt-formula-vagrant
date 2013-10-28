
{% set os = salt['grains.item']('os')['os'] %}

{% set os_family = salt['grains.item']('os_family')['os_family'] %}

{% set cpu_arch = salt['grains.item']('cpuarch')['cpuarch'] %}

{% set kernel = salt['grains.item']('kernel')['kernel'] %}

{% if pillar.vagrant.controller.version is defined %}
{% set vagrant_version = pillar.vagrant.controller.version %}
{% else %}
{% set vagrant_version = '1.3.5' %}
{% endif %}

{% if vagrant_version == "1.2.7" %}
{% set vagrant_hash = '7ec0ee1d00a916f80b109a298bab08e391945243' %}
{% elif vagrant_version == "1.3.3" %}
{% set vagrant_hash = 'db8e7a9c79b23264da129f55cf8569167fc22415' %}
{% elif vagrant_version == "1.3.5" %}
{% set vagrant_hash = 'a40522f5fabccb9ddabad03d836e120ff5d14093' %}
{% endif %}

{% set vagrant_base_url_fragments = [ 'http://files.vagrantup.com/packages/', vagrant_hash ] %}
{% set vagrant_base_url = vagrant_base_url_fragments|join('') %}

{% set vagrant_base_file_fragments = [ 'vagrant_', vagrant_version, '_x86_64.deb' ] %}
{% set vagrant_base_file = vagrant_base_file_fragments|join('') %}

{%- if pillar.vagrant.controller.enabled %}

{%- if kernel == "Linux" %}

vagrant_download_package:
  cmd.run:
  - name: wget {{ vagrant_base_url }}/{{ vagrant_base_file }}
  - unless: "[ -f /root/{{ vagrant_base_file }} ]"
  - cwd: /root

vagrant_package:
  pkg.installed:
  - sources:
    - vagrant: /root/{{ vagrant_base_file }}
  - require:
    - cmd: vagrant_download_package

/srv/vagrant:
  file:
  - directory
  - makedirs: true
  - require:
    - pkg: vagrant_package


{%- endif %}

{%- endif %}
