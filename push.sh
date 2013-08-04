#!/bin/bash

# Script to push the generated site to a webserver

# Build the site
jekyll build

# Push to rcs.rpi.edu
scp -r ./_site/* venkav2@rcs.rpi.edu:~/public_html/

# Push to boyle.che.rpi.edu
# rsync -rvHP ./_site/ venkav2@boyle.che.rpi.edu:~/public_html/
