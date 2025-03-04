#!/bin/bash

# Iniciar el servidor VNC
vncserver :1 -geometry 1440x720 -depth 24

autocutsel -fork

# Iniciar noVNC
/opt/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen $PORT
