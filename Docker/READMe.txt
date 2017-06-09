#Как заранить докер , 
sudo docker run -d -p 9080:8080 -v /var/log/guidoo-server:/myvol guidoo-server
#Лог файл создается /var/log/guidoo-server/guidoo-server.log

#Посмотреть запущенные контейнеры 
sudo docker ps
#Кильнуть контейнер 
docker kill 00e99124e2be

#Сбилдить новый контейнер , перешли в папку с докер файлом , положили что нужно , guidoo-server имя образа
docker build -t guidoo-server .