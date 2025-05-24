#!/bin/bash

# (Opcional) Añade tu authtoken si tienes uno
ngrok authtoken 2xYyOdTgRRlAbD92cfwJO8NcPFF_mMP2JQJiyvxqtFWqFLb9

# Iniciar el broker MQTT (ajusta si tu binario tiene otro nombre)
echo "Iniciando broker MQTT..."
/usr/local/bin/rust &

# Esperar a que el broker se inicie
sleep 5

# Iniciar túnel ngrok al puerto 8883
echo "Iniciando túnel ngrok al puerto 8883..."
ngrok tcp 8883 --log=stdout &
wait
