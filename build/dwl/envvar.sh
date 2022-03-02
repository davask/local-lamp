#!/bin/bash

export DWL_USER_NAME=${CONF_USER_NAME:-`whoami`};
echo "Set DWL_USER_NAME as ${DWL_USER_NAME}";