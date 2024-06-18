#!/bin/bash

## Instalação do CentOS 6 - Cloudera Hadoop

cd ~/Downloads
get http://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm

su 
yum --nogpgcheck localinstall cloudera-cdh-4-0.x86_64.rpm
yum install java-1.7.0-openjdk.x86_64 

# Repositorio
rpm --import http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera

### Instalação 

# JobTracker host running:
yum clean all; 
yum install hadoop-0.20-mapreduce-jobtracker;


# NameNode host running:

yum clean all;
yum install hadoop-hdfs-namenode;

# LZO

"[cloudera-gplextras4]
# Packages for Cloudera's Distribution for Hadoop, Version 4, on RedHat	or CentOS 6 x86_64
name=Cloudera's Distribution for Hadoop, Version 4
baseurl=http://archive.cloudera.com/gplextras/redhat/6/x86_64/gplextras/4/
gpgkey = http://archive.cloudera.com/gplextras/redhat/6/x86_64/gplextras/RPM-GPG-KEY-cloudera    
gpgcheck = 1" >> /etc/yum.repos.d/cloudera-cdh4-extra.repo


yum install hadoop-lzo-cdh4 

# Configurar cluster

hostname localhost

# Configurar Hadoop

cp -r /etc/hadoop/conf.dist /etc/hadoop/conf.vmhadoop

alternatives --verbose --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.vmhadoop 50
alternatives --set hadoop-conf /etc/hadoop/conf.vmhadoop




# Configuração - Continuar:
# http://www.cloudera.com/content/cloudera/en/documentation/cdh4/latest/CDH4-Installation-Guide/cdh4ig_topic_4_4.html?scroll=topic_4_4_2_unique_2
# http://www.cloudera.com/content/cloudera/en/documentation/cdh4/latest/CDH4-Installation-Guide/cdh4ig_topic_11_1.html?scroll=topic_11_1
# http://www.cloudera.com/content/cloudera/en/documentation/cdh4/latest/CDH4-Installation-Guide/cdh4ig_topic_11_2.html#topic_11_2_2_unique_1


