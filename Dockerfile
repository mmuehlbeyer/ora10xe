FROM i386/debian:latest

MAINTAINER mmi 

ENV ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server
ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib
ENV PATH=$ORACLE_HOME/bin:$PATH
ENV ORACLE_SID=XE


RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y \
   bc:i386 \
   libaio1:i386 \
   net-tools \
   curl \
   procps

RUN curl https://oss.oracle.com/debian/dists/unstable/non-free/binary-i386/oracle-xe_10.2.0.1-1.1_i386.deb -o /oracle-xe_10.2.0.1-1.1_i386.deb

RUN dpkg -i /oracle-xe_10.2.0.1-1.1_i386.deb


RUN printf 8080\\n1521\\noracle\\noracle\\ny\\n | /etc/init.d/oracle-xe configure

RUN echo 'export ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server' >> /etc/bash.bashrc
RUN echo 'export LD_LIBRARY_PATH=$ORACLE_HOME/lib' >> /etc/bash.bashrc
RUN echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/bash.bashrc
RUN echo 'export ORACLE_SID=XE' >> /etc/bash.bashrc

# Remove installation files
RUN rm /oracle-xe_10.2.0.1-1.1_i386.deb*
RUN apt-get clean

EXPOSE 1521 

#CMD sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" /usr/lib/oracle/xe/app/oracle/product/10.2.0/server/network/admin/listener.ora; \
CMD service oracle-xe start; \
tail -f /usr/lib/oracle/xe/app/oracle/admin/XE/bdump/alert_XE.log
