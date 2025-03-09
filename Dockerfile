# Use the official QGIS Server image
FROM qgis/qgis:latest

# Install Apache and required modules
RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-fcgid \
    && rm -rf /var/lib/apt/lists/*

# Enable required Apache modules
RUN a2enmod fcgid rewrite headers

# Configure Apache to serve QGIS Server
RUN echo "ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/" >> /etc/apache2/sites-available/000-default.conf && \
    echo "<Directory \"/usr/lib/cgi-bin/\">" >> /etc/apache2/sites-available/000-default.conf && \
    echo "    AllowOverride None" >> /etc/apache2/sites-available/000-default.conf && \
    echo "    Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch" >> /etc/apache2/sites-available/000-default.conf && \
    echo "    Require all granted" >> /etc/apache2/sites-available/000-default.conf && \
    echo "</Directory>" >> /etc/apache2/sites-available/000-default.conf && \
    echo "SetEnv QGIS_SERVER_LOG_STDERR 1" >> /etc/apache2/envvars && \
    echo "SetEnv QGIS_SERVER_LOG_LEVEL 0" >> /etc/apache2/envvars

# Expose the default Apache port
EXPOSE 80

# Start Apache in foreground
CMD ["apachectl", "-D", "FOREGROUND"]
