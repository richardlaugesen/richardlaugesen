#!/bin/bash

git pull

bundle exec jekyll clean
bundle exec jekyll build

rsync -ai --progress --delete _site/ /home/www/richardlaugesen.com/
