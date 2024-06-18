#!/bin/bash

###Site de referencia para o script
##https://mrochadba.wordpress.com/2016/06/25/instalando-oracle-11g-r2-standalone-com-asm-grid-infrastructure-no-linux-6-6/


#yum update -y

#Desabilitar firewalld
systemctl stop firewalld
systemctl disable firewalld


#Requisitos Oracle
yum install -y binutils.x86_64 compat-libcap1.x86_64 gcc.x86_64 gcc-c++.x86_64 glibc.i686 glibc.x86_64 glibc-devel.i686 glibc-devel.x86_64 ksh compat-libstdc++-33 libaio.i686 libaio.x86_64 libaio-devel.i686 libaio-devel.x86_64 libgcc.i686 libgcc.x86_64 libstdc++.i686 libstdc++.x86_64 libstdc++-devel.i686 libstdc++-devel.x86_64 libXi.i686 libXi.x86_64 libXtst.i686 libXtst.x86_64 make.x86_64 sysstat.x86_64 zip unzip

#Repositorio Oracle
#cd /etc/yum.repos.d/
#curl -o public-yum-ol7.repo http://yum.oracle.com/public-yum-ol7.repo
scp public-yum-ol7.repo root@192.168.56.104:/etc/yum.repos.d/public-yum-ol7.repo

#Repositorio ksplice [Reavaliar necessidade]
#curl -o ksplice-uptrack-release.noarch.rpm https://www.ksplice.com/yum/uptrack/ol/ksplice-uptrack-release.noarch.rpm
#rpm -i ksplice-uptrack-release.noarch.rpm

#Atualizar Repositorio
yum repolist


#yum shell 
#> remove --force centos-release-7-2.1511.el7.centos.2.10.x86_64
#> install --force redhat-release-server-1:7.6-4.0.1.el7.x86_64
#> install --force oraclelinux-release-7:7.6-1.0.15.el7.x86_64
#> run

#Rodar esse passo-a-passo
yum shell 
remove --force centos-release-7-2.1511.el7.centos.2.10.x86_64 
install --force redhat-release-server-1:7.6-4.0.1.el7.x86_64 
install --force oraclelinux-release-7:7.6-1.0.15.el7.x86_64 
run


##Desativar SELinux
#gedit /etc/selinux/config

#Instalar requisitos
#yum -y install uptrack
#Pre install 12c R1
yum -y install oracle-rdbms-server-12cR1-preinstall


## Instalação ASM
yum -y install kmod-oracleasm

mkdir -p /u01/app/oracle
chown oracle:oinstall /u01/app/oracle
chmod -R 775 /u01

groupadd -g 503 oper
groupadd -g 1200 asmadmin 
groupadd -g 1201 asmdba 
groupadd -g 1202 asmoper 
useradd -m -u 1100 -g oinstall -G asmadmin,asmdba,asmoper,dba -d /home/grid -s /bin/bash grid 

mkdir -p /u01/app/grid
mkdir -p /u01/app/12.1.0/grid
#chown -R grid:oinstall /u01
chown -R grid:oinstall /u01/app/grid
chown -R oracle:oinstall /u01/app/oracle

#Ja realizado
#groupadd -g 1200 asmadmin 
#groupadd -g 1201 asmdba 
#groupadd -g 1202 asmoper

usermod -G asmdba,asmoper,asmadmin,dba,oper -g oinstall oracle

wget http://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.12-1.el7.x86_64.rpm
#ORIG - wget http://public-yum.oracle.com/repo/OracleLinux/OL7/7/base/x86_64/getPackage/oracleasm-support-2.1.8-1.el7.x86_64.rpm
#wget http://public-yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/oracleasm-support-2.1.8-1.el7.x86_64.rpm

rpm -Uvh oracleasmlib-2.0.12-1.el7.x86_64.rpm
yum install oracleasm-support

cat >> /etc/security/limits.conf <<EOF 
grid soft nproc 2047
grid hard nproc 16384
grid soft nofile 1024
grid hard nofile 65536
EOF

cat >> /etc/pam.d/login <<EOF  
session required pam_limits.so  
EOF

cat >> /etc/profile <<EOF
if [ \$USER = "oracle" ] || [ \$USER = "grid" ]; then
if [ \$SHELL = "/bin/ksh" ]; then
ulimit -p 16384
ulimit -n 65536
else
ulimit -u 16384 -n 65536
fi
umask 022
fi
EOF

#Root - Iniciar montagem ASM
/usr/sbin/oracleasm configure -i

#Default user to own the driver interface []: grid
#Default group to own the driver interface []: asmadmin
#Start Oracle ASM library driver on boot (y/n) [n]: y
#Scan for Oracle ASM disks on boot (y/n) [y]: y
#Writing Oracle ASM library driver configuration: done

/usr/sbin/oracleasm init

/usr/sbin/oracleasm createdisk CRSDISK1 /dev/sdb1
/usr/sbin/oracleasm createdisk CRSDISK2 /dev/sdc1
/usr/sbin/oracleasm createdisk ASMDISK1 /dev/sdd1
/usr/sbin/oracleasm createdisk ASMDISK2 /dev/sde1
/usr/sbin/oracleasm createdisk FRADISK1 /dev/sdf1
/usr/sbin/oracleasm createdisk FRADISK2 /dev/sdg1
/usr/sbin/oracleasm createdisk FRADISK3 /dev/sdh1


/usr/sbin/oracleasm listdisks

oracleasm-discover

#Configurar ASM
asmca #No usuario GRID - Caminho de instalação do grid

