#!/bin/bash

#Desativar modprode ideapad
sudo modprobe -r ideapad-laptop
sudo rfkill unblock all
rfkill list all

sudo -i
echo "blacklist ideapad-laptop"  >>  /etc/modprobe.d/blacklist.conf
modprobe -r ideapad-laptop

#Colocar regional Brasil
sudo iw reg get
sudo iw reg set BR
#sudo gedit /etc/default/crda
echo "REGDOMAIN=BR" >> /etc/default/crda

#Mudar gerencador de Rede
sudo apt-get install -d --reinstall network-manager network-manager-gnome
sudo apt-get purge network-manager-gnome network-manager
sudo apt-get install network-manager-gnome

#Modificar configuração modprobe rtl8723be
sudo modprobe -r rtl8723be
sudo modprobe rtl8723be fwlps=0 swlps=0

echo "options rtl8723be fwlps=0 swlps=0" >>  /etc/modprobe.d/rtl8723be.conf

#echo "options rtl8723be swenc=1"  >>  /etc/modprobe.d/rtl8723be.conf
#Outras opcoes de propriedades
#echo "options rtl8723be fwlps=0" | sudo tee /etc/modprobe.d/rtl8723be.conf

#options rtl8723be swenc=1 fwlps=N ips=N

exit