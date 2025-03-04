#!/bin/bash

# Iniciar el servidor VNC
vncserver :1 -geometry 1366x768 -depth 24

# Iniciar noVNC
/opt/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen $PORT
