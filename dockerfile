FROM ubuntu:18.04

# INFO: avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# INFO: install xfce minimal + deps
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-terminal \
    python2.7 python-gi python-gi-cairo python-cairo \
    gir1.2-gtk-3.0 \
    dbus-x11 x11vnc xvfb \
    wget git supervisor \
    net-tools \
    && apt-get clean

# INFO: install noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
 && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify


# INFO: copy project
COPY seqtrace /opt/seqtrace

# INFO: create desktop shortcut
RUN mkdir -p /root/Desktop && \
    echo "[Desktop Entry]\n\
Name=seqtrace\n\
Exec=python2.7 /opt/seqtrace/src/run_seqtrace.py\n\
Type=Application\n\
Icon=wine\n\
Terminal=false\n" > /root/Desktop/seqtrace.desktop && \
    chmod +x /root/Desktop/seqtrace.desktop

USER root

# INFO: supervisor config
RUN mkdir -p /etc/supervisor/conf.d
COPY xfce4-panel.xml /root/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
COPY xfce4-desktop.xml /root/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 6080

CMD ["/usr/bin/supervisord"]