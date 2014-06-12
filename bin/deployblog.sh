#!/bin/sh

rbenv global 1.9.3-p0
rbenv rehash
rbenv global
ruby --version
rake generate
rake deploy
