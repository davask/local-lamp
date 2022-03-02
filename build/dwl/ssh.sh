#!/bin/bash

if [ "${DWL_SSH_ACCESS}" = "true" ]; then
    sudo sed -i "s|^# AllowUsers username|AllowUsers ${DWL_USER_NAME}|g" /etc/ssh/sshd_config
    sudo sed -i "s|^# Match User username|Match User ${DWL_USER_NAME}|g" /etc/ssh/sshd_config
    # sudo sed -i "s|^#       ChrootDirectory %h|      ChrootDirectory %h|g" /etc/ssh/sshd_config
    sudo sed -i "s|^#       PasswordAuthentication yes|      PasswordAuthentication yes|g" /etc/ssh/sshd_config
    echo "> Enable ssh";
    sudo service ssh start;
else
    echo "> Disable ssh";
fi