#!/bin/bash

# (Opcional) Añade tu authtoken si tienes uno
# ngrok authtoken TU_AUTHTOKEN_AQUI

# Iniciar el broker MQTT (ajusta si tu binario tiene otro nombre)
echo "Iniciando broker MQTT..."
/usr/local/bin/rust &

# Esperar a que el broker se inicie
sleep 5

# Iniciar túnel ngrok al puerto 8883
echo "Iniciando túnel ngrok al puerto 8883..."
ngrok tcp 8883 --log=stdout &
wait
