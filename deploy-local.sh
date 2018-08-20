#!/bin/bash

bundle exec jekyll build

rsync -ai --progress --delete _site/ /home/www/richardlaugesen.com/
