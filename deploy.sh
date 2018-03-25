#!/bin/bash

bundle exec jekyll build

sudo rm -rf /var/www/html/b/*
sudo cp -rv _site/* /var/www/html/b/

#rsync -ai --progress --delete -e 'ssh -p 8666' _site/ richard@dirac.tinyrock.com:/home/www/richardlaugesen.com/
