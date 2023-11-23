#!/bin/bash

### Docker installation

#Update OS packages
sudo yum update -y

#Install Docker
sudo amazon-linux-extras install docker

#Start Docker
sudo service docker start

#Enable it
sudo systemctl enable docker

#Add user to docker group
sudo usermod -a -G docker ec2-user

#Just logout and login again to run docker commands with normal user.