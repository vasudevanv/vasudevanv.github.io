#!/bin/bash

# Script to push the generated site to a webserver

# Push to rcs.rpi.edu
jekyll build
rsync -rvHP --exclude='index-bkp.html' --exclude='push.sh' \
    ./_site/ venkav2@rcs.rpi.edu:~/public_html/
# rsync -rHP assets venkav2@boyle.che.rpi.edu:~/
