FROM ubuntu:16.04
MAINTAINER superbigfu wangwenfu228@gmail.com

ENV LANG="en_US.UTF8"
ENV MYSQL_ROOT_PASSWORD="123456"
ENV ZIP_URL="http://dl.cnezsoft.com/zentao/12.1/ZenTaoPMS.12.1.stable.zip"


RUN apt-get update && \
    apt-get update && apt-get install -y apache2 mariadb-server php php-curl php-gd php-ldap php-mbstring php-mcrypt php-mysql php-xml php-zip php-cli php-json curl unzip libapache2-mod-php locales && \
    echo -e "LANG=\"en_US.UTF-8\"\nLANGUAGE=\"en_US:en\"" > /etc/default/locale && locale-gen en_US.UTF-8 && \
    mkdir -p /app/zentaopms && \
    random=`date +%s`; curl $ZIP_URL?rand=$random -o /var/www/zentao.zip && \
    cd /var/www/ && unzip -q zentao.zip && rm zentao.zip && \
    a2enmod rewrite && \
    rm -rf /etc/apache2/sites-enabled/000-default.conf /var/lib/mysql/* && \
    sed -i '1i ServerName 127.0.0.1' /etc/apache2/apache2.conf

COPY docker-entrypoint.sh /app
COPY config/apache.conf /etc/apache2/sites-enabled/000-default.conf
COPY config/ioncube_loader_lin_7.0.so /usr/lib/php/20151012/ioncube_loader_lin_7.0.so
COPY config/00-ioncube.ini /etc/php/7.0/apache2/conf.d/
COPY config/00-ioncube.ini /etc/php/7.0/cli/conf.d/

RUN chmod 777 /app/docker-entrypoint.sh

VOLUME /app/zentaopms /var/lib/mysql
ENTRYPOINT ["/app/docker-entrypoint.sh"]
