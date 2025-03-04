# Usar una imagen base ligera de Ubuntu
FROM ubuntu:20.04

# Configurar la zona horaria de manera no interactiva
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV USER=root

# Instalar herramientas esenciales antes de agregar claves
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 ca-certificates curl wget && \
    rm -rf /var/lib/apt/lists/*

# Agregar clave GPG de Debian de forma segura
RUN wget -qO - https://ftp-master.debian.org/keys/archive-key-11.asc | gpg --dearmour -o /usr/share/keyrings/debian-archive-keyring.gpg

# Agregar repositorio de Debian Bullseye con clave firmada
RUN echo "deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://deb.debian.org/debian bullseye main" | tee /etc/apt/sources.list.d/debian.list

# Instalar dependencias (LXDE en lugar de Lubuntu)
RUN apt-get update && apt-get install -y \
    lxde-core \
    tightvncserver \
    websockify \
    git \
    python3 \
    tzdata \
    xapian-tools \
    language-pack-es language-pack-es-base \
    apt-transport-https curl \
    firefox-esr \
    unzip \
    autocutsel > /dev/null 2>&1 && \
    rm -rf /var/lib/apt/lists/*

# Clonar noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC > /dev/null 2>&1

# Configurar VNC
RUN mkdir ~/.vnc && \
    echo "1234" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# Configurar LXDE como entorno de escritorio para VNC
RUN echo '#!/bin/bash' > ~/.vnc/xstartup && \
    echo 'autocutsel -fork &' >> ~/.vnc/xstartup && \
    echo 'startlxde &' >> ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

# Exponer puertos
#EXPOSE 6080 5901

# Copiar el script de inicio
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Comando de inicio
CMD ["/usr/local/bin/start.sh"]
