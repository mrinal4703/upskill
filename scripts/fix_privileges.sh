#!/usr/bin/env bash
chmod +x /home/ubuntu/Target/*.war
chmod +x /home/ubuntu/Target/server_start.sh
chmod +x /home/ubuntu/Target/server_stop.sh
sudo chmod o+w /home/ubuntu/apache-tomcat-9.0.89/webapps/
cp /home/ubuntu/Target/*.war /home/ubuntu/apache-tomcat-9.0.89/webapps/
#
#chmod +x /home/ubuntu/Target/*.war
#chmod +x /home/ubuntu/Target/server_start.sh
#chmod +x /home/ubuntu/Target/server_stop.sh
#sudo chmod o+w /home/ubuntu/apache-tomcat-9.0.71/webapps/
#cp /home/ubuntu/Target/*.war /home/ubuntu/apache-tomcat-9.0.71/webapps/