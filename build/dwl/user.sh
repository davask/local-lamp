#!/bin/bash

# declare user
if [ "`grep ^${DWL_USER_NAME} /etc/passwd | wc -l`" == 0 ]; then
    echo "> Declare user ${DWL_USER_NAME}";
    # declare group user
    sudo useradd -r \
        --comment "dwl ssh user" \
        --home-dir /home/${DWL_USER_NAME} \
        --`if sudo [ -d /home/${DWL_USER_NAME} ]; then echo "no-"; fi`create-home \
        --password $(echo "${DWL_USER_PASSWD}" | openssl passwd -1 -stdin) \
        --shell /bin/bash \
        --uid ${DWL_USER_ID} \
        --user-group \
        ${DWL_USER_NAME};

    if [ "${DWL_SUDO_USER}" == "true" ]; then
        echo "${DWL_USER_NAME}    ALL=(ALL:ALL) ALL" | sudo tee /etc/sudoers.d/${DWL_USER_NAME};
        sudo chmod 0440 /etc/sudoers.d/${DWL_USER_NAME}
    fi;

fi;