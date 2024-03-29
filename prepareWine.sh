apt update
# apt upgrade 
apt-get install -y -q --no-install-recommends libgtkglext1 libpango1.0-0 libpangox-1.0-0 libgtk2.0-0 
# apt install -y libgtkglext1 libpango1.0-0 libpangox-1.0-0 libgtk2.0-0 

VIRTUALGL_VERSION=2.6.1
TURBOVNC_VERSION=2.2.1
LIBJPEG_VERSION=2.0.2
NOVNC_VERSION=1.0.0
WEBSOCKIFY_VERSION=0.8.0
ANYDESK_VERSION=4.0.1-1

CWD=$(pwd)
mkdir -p /opt

# TurboVNC + VirtualGL
cd /tmp
curl -fsSL -O https://sourceforge.net/projects/turbovnc/files/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb
curl -fsSL -O https://sourceforge.net/projects/libjpeg-turbo/files/${LIBJPEG_VERSION}/libjpeg-turbo-official_${LIBJPEG_VERSION}_amd64.deb
curl -fsSL -O https://sourceforge.net/projects/virtualgl/files/${VIRTUALGL_VERSION}/virtualgl_${VIRTUALGL_VERSION}_amd64.deb
curl -fsSL -O https://download.anydesk.com/linux/anydesk_${ANYDESK_VERSION}_amd64.deb
dpkg -i *.deb
sed -i 's/$host:/unix:/g' /opt/TurboVNC/bin/vncserver
rm -f /tmp/*.deb

# noVNC
curl -fsSL https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz | tar -xzf - -C /opt 
curl -fsSL https://github.com/novnc/websockify/archive/v${WEBSOCKIFY_VERSION}.tar.gz | tar -xzf - -C /opt 
rm -rf /opt/noVNC
mv /opt/noVNC-${NOVNC_VERSION} /opt/noVNC
rm -rf /opt/websockify
mv /opt/websockify-${WEBSOCKIFY_VERSION} /opt/websockify
ln -s /opt/noVNC/vnc_lite.html /opt/noVNC/index.html
cd /opt/websockify
make  > /dev/null

# X11 
apt-get install -y -q  \
        ca-certificates \
        vim.tiny \
        nano \
        libc6-dev \
        libglu1 \
        libsm6 \
        libxv1 \
        x11-xkb-utils \
        x11-xserver-utils \
        x11-utils \
        xauth \
        xfonts-base \
        xkb-data \
        scrot \
        xterm \
        xvfb \
        x11vnc \
        xtightvncviewer \
        mesa-utils \
        python-opengl \
        openbox \
        xfce4 \
        xfce4-goodies \
        gvfs libgail-common libgtk2.0-bin \
        onboard \
    > /dev/null
    
cd ${CWD}


#         curl \
#         xfce4-terminal \

# Xvfb (仮想ディスプレイ)
# apt-get -q -y install xvfb > /dev/null

# Web ブラウザ（Epiphany）
add-apt-repository -r -y ppa:gnome3-team/gnome3 > /dev/null
add-apt-repository -y ppa:gnome3-team/gnome3 > /dev/null
apt-get -q -y install epiphany-browser > /dev/null

# Ngrok
mkdir -p /content/.vnc
curl -fsSL -O https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
rm /opt/ngrok
unzip -d /opt ngrok-stable-linux-amd64.zip
rm ngrok-stable-linux-amd64.zip 
echo "web_addr: 4045" > /content/config.yml

# WineHQ
dpkg --add-architecture i386
wget -nc https://dl.winehq.org/wine-builds/winehq.key
apt-key add winehq.key
apt-add-repository -y 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
apt-get install -q -y --no-install-recommends wine-stable winetricks zenity

# Xmodmap
cat << EOS > ~/.Xmodmap
keycode 111 = Up
keycode 116 = Down
keycode 113 = Left
keycode 114 = Right
EOS
#/opt/websockify/run 5901 --web=/opt/noVNC --wrap-mode=ignore -- /opt/TurboVNC/bin/vncserver :1 -depth 24 -geometry 1600x900 -securitytypes otp -otp -noxstartup > /content/.vnc/stdout 2>&1 &
#DISPLAY=:1 xmodmap ~/.Xmodmap
