# Скачиваем
sudo wget -c https://github.com/YouROK/TorrServer/releases/download/MatriX.117/TorrServer-linux-amd64 -O /usr/bin/torrserver
# Даем право на выполнение
sudo chmod +x /usr/bin/torrserver
# Скачиваем юнит для systemd
sudo wget https://raw.githubusercontent.com/YouROK/TorrServer/master/torrserver.service -O /usr/lib/systemd/system/torrserver.service
# Фиксим пути к бинарнику и базе данных
sudo sed -i "s/path\/to\/torrserver/usr\/bin\/torrserver/g" /usr/lib/systemd/system/torrserver.service
sudo sed -i "s/path\/to\/db\//tmp/g" /usr/lib/systemd/system/torrserver.service
# Включаем и запускаем юнит
sudo systemctl daemon-reload
sudo systemctl enable torrserver
sudo systemctl start torrserver
# Проверяем
xdg-open http://localhost:8090
