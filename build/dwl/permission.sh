#!/bin/bash

# if sudo [ ! -d /dwl/home/host ]; then
#     sudo mkdir -p /dwl/home/host;
# fi
# if sudo [ -d /dwl/home/host/files ]; then
#     if sudo [ -f /home/${DWL_USER_NAME}/files ]; then
#         sudo rm -f /home/${DWL_USER_NAME}/files;
#     fi
#     if sudo [ -d /home/${DWL_USER_NAME}/files ]; then
#         sudo rm -rdf /home/${DWL_USER_NAME}/files;
#     fi
#     sudo cp -rdf /dwl/home/host/files /home/${DWL_USER_NAME};
# fi

sudo chown -R ${DWL_USER_NAME}:${DWL_USER_NAME} /home/${DWL_USER_NAME}/;
# sudo chown root:root /home/${DWL_USER_NAME};