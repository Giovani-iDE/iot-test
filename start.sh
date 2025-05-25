#!/bin/bash

# Iniciar broker MQTT
echo "Iniciando broker MQTT..."
/usr/local/bin/rust &

# Esperar a que el broker inicie
sleep 5

# Abrir túnel TCP en Serveo hacia el puerto 8883 local
echo "Iniciando túnel Serveo en el puerto 8883..."
ssh -o StrictHostKeyChecking=no -R 0:localhost:8883 serveo.net

