# Java

Installs openjdk-1.7.0 devel and sets up some variables for later
use

# Input variables

## Memory and GC options
* `java_jvm_mem_heap` - total heap memory (e.g. 512m or 2g)
* `java_jvm_mem_new` - size of new memory
* `java_jvm_mem_perm` - size of perm gen
* `java_gc_log` - path to GC log file (e.g. `/var/log/jenkins/gc.log.\`date +%Y%m%d-%H%M\``)
* `java_keystore_password` - password for keystore. Defaults to changeit

## JMX Options

* `java_remote_jmx` - if `true`, enable remote JMX and open up firewall
* `java_jmx_users` - list of dicts of usernames, passwords and roles for JMX. e.g.
  ```
  java_jmx_users:
  - { username: monitor, password: welcome, role: readonly }
  - { username: admin, password: "{{secret_admin_password}}", role: readwrite }
  ```
* `java_jmx_port` - port to listen for JMX. Defaults to 8199
* `java_user` - user that runs java - for ownership of restricted jmx access files

# Output variables

* `java_jvm_options` - sets up useful java variables (e.g. GC logging, JMX settings etc.)
