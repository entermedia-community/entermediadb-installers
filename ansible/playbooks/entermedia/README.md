# PreTasks:  
Edit file entermediadb-installers/ansible/inventory/entermedia.   
Replace dam.host.name.com with the host or list of hosts you wish to install on.  
This will allow you to install to one or to many hosts simultaneously by using an inventory file to define hosts.  

# To run the installer:  
```bash
cd entermediadb-installers/ansible  
ansible-playbook -vv playbooks/entermedia/install.yml  
```

# User Defineable Variables  
These can be overridden in entermediadb-installers/ansible/inventory/group_vars/em-stage or em-prod  
```yaml
server_log_location: "/usr/share/tomcat/logs"  
tomcat_mgr_user: "tomcat"  
tomcat_mgr_password: "tomcat"  
tomcat_admin_user: "admin"  
tomcat_admin_password: "adminadmin"  
```
