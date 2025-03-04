# Usar una imagen base ligera de Ubuntu
FROM ubuntu:20.04

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    lubuntu-desktop \
    tightvncserver \
    && rm -rf /var/lib/apt/lists/*

# Establecer la contraseña de VNC (cambia "password" por tu contraseña)
RUN mkdir ~/.vnc
RUN echo "1234" | vncpasswd -f > ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd

# Copiar el script de inicio al contenedor
COPY start-vnc.sh /usr/local/bin/start-vnc.sh
RUN chmod +x /usr/local/bin/start-vnc.sh

# Exponer el puerto de VNC (Clever Cloud manejará el puerto dinámico)
EXPOSE 5901

# Ejecutar el script de inicio al iniciar el contenedor
CMD ["/usr/local/bin/start-vnc.sh"]
