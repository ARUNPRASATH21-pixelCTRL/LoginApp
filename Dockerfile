# Use lightweight Java runtime
FROM eclipse-temurin:23-jre

# Set Tomcat path
ENV CATALINA_HOME=/opt/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH

# Install curl
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Download Tomcat 10
RUN mkdir -p $CATALINA_HOME && \
    curl -fsSL https://downloads.apache.org/tomcat/tomcat-10/v10.1.28/bin/apache-tomcat-10.1.28.tar.gz \
    | tar -xzC $CATALINA_HOME --strip-components=1

# Remove default apps
RUN rm -rf $CATALINA_HOME/webapps/*

# Copy WAR from your GitHub repo
# IMPORTANT: make sure WAR file is in repo root OR adjust path
COPY yourapp.war $CATALINA_HOME/webapps/ROOT.war

# Render uses dynamic port → use PORT env variable
EXPOSE 8080

# Start Tomcat on Render's PORT
CMD ["sh", "-c", "catalina.sh run"]
