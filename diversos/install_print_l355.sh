#!/bin/bash

sudo apt-get update
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8AA65D56
#sudo apt-get install epson-inkjet-printer-201207w

sudo apt-get install xsltproc 
sudo dpkg -i L355/epson-inkjet-printer-201207w_1.0.0-1lsb3.2_amd64.deb 
sudo dpkg -i L355/iscan*deb

echo "Drivers Instalados!!!"
echo "Acessar localhost:631 (Browser)"
#echo "Qualquer duvida acessar link: http://dicas-de-linux.blogspot.com.br/2014/05/instalando-epson-l355-no-ubuntu-1404-e.html"
