FROM        ubuntu:14.04
MAINTAINER  Odewumi Babarinde Ayodeji "odewumibabarinde@abbaandking.com"

# Set the enviroment variable
ENV DEBIAN_FRONTEND noninteractive


# Install required packages
RUN apt-get clean all
RUN apt-get update  
RUN apt-get -y install supervisor 
RUN apt-get -y install apache2 
RUN apt-get -y install php5-cli php5 libapache2-mod-php5 php5-mysql php5-gd php5-mcrypt php-pear php5-mongo php-apc php5-curl curl lynx-cur php5-dev php5-imagick php5-intl  
RUN apt-get -y install git vim wget build-essential
RUN sudo php5enmod mcrypt

#Install php-mongo extension 1.3.2
RUN wget https://github.com/mongodb/mongo-php-driver/archive/1.3.2.tar.gz
RUN tar zvxf 1.3.2.tar.gz
WORKDIR /mongo-php-driver-1.3.2
RUN phpize
RUN ./configure
RUN make all
RUN sudo make install
WORKDIR /

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


EXPOSE 80

CMD ["/run.sh"]
