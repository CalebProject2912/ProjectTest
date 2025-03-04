# Usar una imagen base ligera de Ubuntu
FROM ubuntu:20.04

# Configurar la zona horaria de manera no interactiva
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV USER=root

# Agregar repositorio de Debian para obtener Firefox ESR
RUN echo "deb http://deb.debian.org/debian bullseye main" | tee -a /etc/apt/sources.list.d/debian.list

# Instalar gnupg antes de agregar claves
RUN apt-get update && apt-get install -y gnupg

# Agregar claves GPG faltantes
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9 6ED0E7B82643E131 605C66F00D6C9793 || \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0E98404D386FA1D9 6ED0E7B82643E131 605C66F00D6C9793 || \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 0E98404D386FA1D9 6ED0E7B82643E131 605C66F00D6C9793

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
