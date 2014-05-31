===========
ssh-formula
===========

Salt Stack Formula to set up and configure OpenSSH

NOTICE BEFORE YOU USE
=====================

* This formula aims to follow the conventions and recommendations described at http://docs.saltstack.com/topics/conventions/formulas.html

TODO
====

* manage known hosts in ssh.keys

Instructions
============

1. Add this repository as a `GitFS <http://docs.saltstack.com/topics/tutorials/gitfs.html>`_ backend in your Salt master config.

2. Configure your Pillar top file (``/srv/pillar/top.sls``), see pillar.example

3. Include this Formula within another Formula or simply define your needed states within the Salt top file (``/srv/salt/top.sls``).

Available states
================

.. contents::
    :local:

``ssh``
-------

Includes:

* ``ssh.server``
* ``ssh.client``

``ssh.client``
--------------
Installs and configures ssh client

``ssh.server``
--------------
Installs and configures ssh server


Additional resources
====================

* based on https://github.com/saltstack-formulas/openssh-formula/

Templates
=========

Some states/ commands may refer to templates which aren't included in the files folder (``template/files``). Take a look at ``contrib/`` (if present) for e.g. template examples and place them in separate file roots (e.g. Git repository, refer to `GitFS <http://docs.saltstack.com/topics/tutorials/gitfs.html>`_) in your Salt master config.

Formula Dependencies
====================

None

Contributions
=============

Contributions are always welcome. All development guidelines you have to know are

* write clean code (proper YAML+Jinja syntax, no trailing whitespaces, no empty lines with whitespaces, LF only)
* set sane default settings
* test your code
* update README.rst doc

Salt Compatibility
==================

Tested with:

* 2014.1.4

OS Compatibility
================

Tested with:

* GNU/ Linux Debian Wheezy
* CentOS 6 (partly)
