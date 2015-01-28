FROM        ubuntu:14.04
MAINTAINER  Odewumi Babarinde Ayodeji "odewumibabarinde@abbaandking.com"

# Set the enviroment variable
ENV DEBIAN_FRONTEND noninteractive

# Added dotdeb to apt
#RUN echo "deb http://packages.dotdeb.org wheezy-php55 all" >> /etc/apt/sources.list.d/dotdeb.org.list && \
#	echo "deb-src http://packages.dotdeb.org wheezy-php55 all" >> /etc/apt/sources.list.d/dotdeb.org.list && \
	#wget -O- http://www.dotdeb.org/dotdeb.gpg | apt-key add -

# Install required packages
RUN apt-get clean all
RUN apt-get update 
RUN apt-get -y install supervisor 
RUN apt-get -y install apache2 
RUN apt-get -y install php5-cli php5 libapache2-mod-php5 php5-mysql php5-gd php-pear php-apc php5-curl curl lynx-cur php5-mongo php5-imagick php5-intl  
RUN apt-get -y install git vim wget

# Add shell scripts for starting apache2
ADD apache2-start.sh /apache2-start.sh

ADD run.sh /run.sh

# Give the execution permissions
RUN chmod 755 /*.sh

# Add the Configurations files
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Enable apache mods.
RUN a2enmod php5
RUN a2enmod rewrite

# Let's set the default timezone in both cli and apache configs
#RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Africa\/Lagos/g' /etc/php5/cli/php.ini
#RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Africa\/Lagos/g' /etc/php5/apache2/php.ini

ADD ./001-docker.conf /etc/apache2/sites-enabled/000-default.conf
RUN rm -rf /var/www/html/

#logging to papertrail
RUN wget https://github.com/papertrail/remote_syslog2/releases/download/v0.13/remote_syslog_linux_amd64.tar.gz
RUN tar xzf ./remote_syslog*.tar.gz
RUN sudo cp ./remote_syslog/* /usr/local/bin

EXPOSE 80
