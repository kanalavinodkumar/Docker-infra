#!/bin/bash

#Jenkins installation

DATE=$(date +%F)
LOG="Jenkins_Install_${DATE}.log"
G="\e[32m"
R="\e[31m"
N="\e[0m"


validate(){
	if [ $? -ne 0 ]; then
		echo -e "$1 : ${R} Failure ${N}" 2>&1 | tee	-a $LOG
		exit 1
	else
		echo -e "$1 : $G Success $N" 2>&1 | tee	-a $LOG
	fi
}


sudo yum update -y &>>$LOG
validate "Yum update"

sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo &>>$LOG
validate "Download Jenkins repo"

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key &>>$LOG
validate "Import key"

sudo yum upgrade &>>$LOG
validate "Yum upgrade"

sudo amazon-linux-extras install java-openjdk11 -y &>>$LOG
validate "JDK install"

#sudo dnf install java-11-amazon-corretto -y &>>$LOG
#validate "Java install"

sudo yum install jenkins -y &>>$LOG
validate "Jenkins install"

sudo systemctl enable jenkins &>>$LOG
validate "Jenkins enable"

sudo systemctl start jenkins &>>$LOG
validate "Jenkins start"

sudo systemctl status jenkins &>>$LOG