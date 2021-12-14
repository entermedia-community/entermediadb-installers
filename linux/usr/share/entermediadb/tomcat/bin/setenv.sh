export JAVA_OPTS="-Dlog4j2.formatMsgNoLookups=true -server -Xss300k -Xms256m -Xmx8g -XX:+UseG1GC -XX:MaxGCPauseMillis=500  -XX:+UseStringDeduplication -Djava.security.egd=file:///dev/urandom"

export CATALINA_HOME="/usr/share/entermediadb/tomcat"
