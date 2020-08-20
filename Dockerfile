  
FROM ubuntu:latest
MAINTAINER River riou

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV ACCEPT_EULA N
ENV MSSQL_PID standard
ENV MSSQL_SA_PASSWORD sasa
ENV MSSQL_TCP_PORT 1433


RUN ln -snf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && echo Asia/Taipei > /etc/timezone


WORKDIR /data
ADD . /data
RUN chmod 755 /data/mssql2019.sh
RUN /data/mssql2019.sh
RUN rm -r /data

RUN apt-get install -y nodejs npm supervisor
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*    

RUN echo "[supervisord] " >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "user=root" >> /etc/supervisor/conf.d/supervisord.conf

RUN echo "[program:apache2]" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo 'command=/bin/bash -c "source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND"' >> /etc/supervisor/conf.d/supervisord.conf

RUN echo '#!/bin/sh' >> /startup.sh
RUN echo 'service apache2 restart' >> /startup.sh
RUN echo '/opt/mssql/bin/sqlservr' >> /startup.sh
RUN echo 'exec supervisord -c /etc/supervisor/supervisord.conf' >> /startup.sh

RUN chmod +x /startup.sh

EXPOSE  80
CMD ["/startup.sh"]
