#!/bin/bash

set -e # stop script execution after failure of any command
set -x # print all executed commands

pip list --format=freeze > requirements.txt

