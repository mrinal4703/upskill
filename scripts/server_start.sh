#!/usr/bin/env bash
## Define variables
#TOMCAT_HOME="/home/ubuntu/apache-tomcat-9.0.71"
#CATALINA_SH="${TOMCAT_HOME}/bin/catalina.sh"
#LOG_FILE="${TOMCAT_HOME}/logs/catalina.out"
#
## Change directory to Tomcat bin directory
#cd "${TOMCAT_HOME}/bin" || exit
#
## Ensure catalina.sh script has execute permission
#sudo chmod +x "${CATALINA_SH}"
#
## Start Tomcat server using nohup and redirect output to a log file
#sudo nohup "${CATALINA_SH}" start &

# Define variables
TOMCAT_HOME="/home/ubuntu/apache-tomcat-9.0.89"
CATALINA_SH="${TOMCAT_HOME}/bin/catalina.sh"
LOG_FILE="${TOMCAT_HOME}/logs/catalina.out"

# Change directory to Tomcat bin directory
cd "${TOMCAT_HOME}/bin" || exit

# Ensure catalina.sh script has execute permission
sudo chmod +x "${CATALINA_SH}"

# Start Tomcat server using nohup and redirect output to a log file
sudo nohup "${CATALINA_SH}" start &
