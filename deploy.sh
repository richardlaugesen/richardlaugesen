#!/bin/bash

bundle exec jekyll build

rsync -ai --progress --delete -e 'ssh -p 8666' _site/ fedora@tinyrock.com:/var/www/richardlaugesen/
