# Usar una imagen base ligera de Ubuntu
FROM ubuntu:20.04

# Configurar la zona horaria de manera no interactiva
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    lubuntu-desktop \
    tightvncserver \
    websockify \
    git \
    python3 \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Clonar noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC

# Configurar VNC
RUN mkdir ~/.vnc
RUN echo "password" | vncpasswd -f > ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd

# Exponer puertos
EXPOSE 6080 5901

# Copiar el script de inicio
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Comando de inicio
CMD ["/usr/local/bin/start.sh"]
