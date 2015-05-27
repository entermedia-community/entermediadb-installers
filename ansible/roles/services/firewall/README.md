Overview
========

this module provides a firewall framework that allows individual roles to add their own rules without the issue of manglining rules for other roles.

RHEL6
=====
Rhel6 uses iptables by default.  This role provides a flattened firewall template system compatible with IT's implementation.  It also allows for applications to drop in additional rules without worrying about conflicting with others


RHEL 7
======
Rhel 7 uses firewalld by default.  The framework here should provide equivalent function to make creating rules for rhel 6 and rhel 7 much easier.

If force_firewall_baseline_rhel7 is defined, It will stop firewalld and install needed packages to make this role work.  This mode may be desirable in PHX environment where IT use this by default on RHEL7 deployments

'''
firewall_type=iptables-flattened 

Can be defined for rhel7 systems.  In this case it will replace the firewalld package with iptables and allow the flattened layout to work


Defines
=======
The role defines firewall_type for other roles to make subsequent decisions.  Alternatively the presence of '/usr/local/bin/iptables-update.sh' could be used in environments where supplied by IT

The handler **apply firewall** is provided for the iptables provided layout and should be called after adding/changing templates/files within the framework **NOTE handles cannot be called from outside ofthe playbook a this time, place the firewall role last and it will include the previoulsy placed files**

Example of enabling http and https with coresponding file:

'''
- name: configure firewall (iptables)
  file: src=httpd dest=/etc/sysconfig/iptables.d/httpd 
  when: firewall_type == "iptables-flattened"
  notify: apply firewall

'''
-A INPUT -p tcp --destination-port 80 -j ACCEPT
-A INPUT -p tcp --destination-port 443 -j ACCEPT



The firewalld equivalent setup would look something like this:

'''
- name: open firewall for https (firewalld)
  firewalld: service=https permanent=true state=enabled
  when: firewall_type == "firewalld"
  
- name: open firewall for http (firewalld)
  firewalld: service=http permanent=true state=enabled
  when: firewall_type == "firewalld"


No handler is required for firewalld


Defaults
========
Ports are opened for ssh and zabbix agent by default


TODO
====
- relocate zabbix enablement to zabbix client role?
- adjust reject vs drop silent policy for external/DMZ targets
