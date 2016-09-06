FROM ubuntu:14.04
MAINTAINER Aneesh Vijendran <aneesh.vijendran@negociosit.com>
 
RUN apt-get update && \
    apt-get install -yq \
        apache2 \
        libapache2-mod-proxy-html libxml2-dev curl lynx-cur && \
    	apt-get clean

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid  
ENV TERM=xterm  

EXPOSE 80 443

ADD run-apache2-foreground.sh /usr/local/bin

RUN chmod +x /usr/local/bin/run-apache2-foreground.sh && \
			 sudo a2enmod ssl && \ 
			 sudo a2enmod rewrite && \
			 ln -s /etc/apache2/mods-available/proxy_http.load /etc/apache2/mods-enabled/proxy_http.load && \
			 ln -s /etc/apache2/mods-available/proxy_ajp.load /etc/apache2/mods-enabled/proxy_ajp.load && \
			 ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/proxy.load && \
			 ln -s /etc/apache2/mods-available/proxy.conf /etc/apache2/mods-enabled/proxy.conf && \
			 sudo mkdir /etc/apache2/certs && \
			 sudo chmod +x /etc/apache2/certs && \
			 chmod +x /etc/apache2/mods-enabled/proxy*.*

 
# CMD /usr/sbin/apache2ctl -D FOREGROUND
# Using this file  as apache complains when starting the conteiner again that pid file exists
CMD ["run-apache2-foreground.sh"]
