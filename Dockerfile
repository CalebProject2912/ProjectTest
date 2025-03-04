# Usar una imagen base ligera de Ubuntu
FROM ubuntu:20.04

# Configurar la zona horaria de manera no interactiva
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Instalar dependencias (LXDE en lugar de Lubuntu)
RUN apt-get update && apt-get install -y \
    lxde-core \
    tightvncserver \
    websockify \
    git \
    python3 \
    tzdata \
    xapian-tools > /dev/null 2>&1 && \
    rm -rf /var/lib/apt/lists/*

# Construir el índice de Xapian para evitar el mensaje
RUN mkdir -p /var/cache/apt/xapian && \
    update-apt-xapian-index > /dev/null 2>&1

# Clonar noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC > /dev/null 2>&1

# Configurar VNC
RUN mkdir ~/.vnc && \
    echo "password" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# Configurar LXDE como entorno de escritorio para VNC
RUN echo '#!/bin/bash' > ~/.vnc/xstartup && \
    echo 'startlxde &' >> ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

# Exponer puertos
EXPOSE 6080 5901

# Copiar el script de inicio
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Comando de inicio
CMD ["/usr/local/bin/start.sh"]
