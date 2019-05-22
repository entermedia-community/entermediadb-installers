export JAVA_OPTS="-server -Xms256m -Xmx8g -XX:UseContainerSupport -XX:+UseG1GC -XX:MaxGCPauseMillis=500  -XX:+UseStringDeduplication -Djava.security.egd=file:///dev/urandom"

export CATALINA_HOME="/usr/share/entermediadb/tomcat"
