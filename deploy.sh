#!/bin/bash

rsync -av --progress -e 'ssh -p 8666' _site/ fedora@tinyrock.com:/var/www/richardlaugesen/
