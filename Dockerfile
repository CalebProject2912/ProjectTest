# Usar una imagen base ligera de Ubuntu
FROM ubuntu:20.04

# Configurar la zona horaria de manera no interactiva
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV USER=root

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
    apt-transport-https curl > /dev/null 2>&1 && \
    rm -rf /var/lib/apt/lists/*

# Agregar el repositorio de Brave
RUN curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add - && \
    echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list && \
    apt-get update && \
    apt-get install -y brave-browser > /dev/null 2>&1 && \
    rm -rf /var/lib/apt/lists/*

# Clonar noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC > /dev/null 2>&1

# Configurar VNC
RUN mkdir ~/.vnc && \
    echo "1234" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# Configurar LXDE como entorno de escritorio para VNC
RUN echo '#!/bin/bash' > ~/.vnc/xstartup && \
    echo 'startlxde &' >> ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

# Exponer puertos
#EXPOSE 6080 5901

# Copiar el script de inicio
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Comando de inicio
CMD ["/usr/local/bin/start.sh"]
