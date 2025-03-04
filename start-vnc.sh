#!/bin/bash

# Obtener el puerto asignado por Clever Cloud
PORT=$(echo $CC_PORTS | cut -d' ' -f1)

# Iniciar el servidor VNC en el puerto asignado
vncserver :1 -geometry 1280x800 -depth 24 -rfbport $PORT

# Mantener el contenedor en ejecución
tail -f /dev/null
