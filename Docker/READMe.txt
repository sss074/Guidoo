#��� �������� ����� , 
sudo docker run -d -p 9080:8080 -v /var/log/guidoo-server:/myvol guidoo-server
#��� ���� ��������� /var/log/guidoo-server/guidoo-server.log

#���������� ���������� ���������� 
sudo docker ps
#�������� ��������� 
docker kill 00e99124e2be

#�������� ����� ��������� , ������� � ����� � ����� ������ , �������� ��� ����� , guidoo-server ��� ������
docker build -t guidoo-server .