#!/bin/bash
#Nombrar las maquinas en el host
echo "192.168.56.4 testing" | sudo tee -a /etc/hosts
echo "192.168.56.5 production" | sudo tee -a /etc/hosts

#Remover contraseña al usar sudo
if sudo grep -q "^vagrant ALL=(ALL) NOPASSWD:ALL" /etc/sudoers; then
    echo "La configuración de sudo sin contraseña ya está aplicada."
else
    echo "Agregando configuración de sudo sin contraseña para el usuario vagrant..."
    echo "vagrant ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo
fi
