FROM eclipse-temurin:23-jre

ENV CATALINA_HOME=/opt/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH

RUN apt-get update && \
    apt-get install -y curl tar && \
    rm -rf /var/lib/apt/lists/*

# ✅ Download Tomcat safely
RUN mkdir -p $CATALINA_HOME && \
    curl -fLo /tmp/tomcat.tar.gz https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.28/bin/apache-tomcat-10.1.28.tar.gz && \
    tar -xzf /tmp/tomcat.tar.gz -C $CATALINA_HOME --strip-components=1 && \
    rm /tmp/tomcat.tar.gz

# Remove default apps
RUN rm -rf $CATALINA_HOME/webapps/*

# Render dynamic port fix
RUN sed -i 's/port="8080"/port="${PORT:-8080}"/' $CATALINA_HOME/conf/server.xml

# 👇 FIX THIS NAME based on your actual WAR
COPY LoginApp.war $CATALINA_HOME/webapps/ROOT.war

CMD ["sh", "-c", "catalina.sh run"]
