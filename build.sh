#!/bin/sh -Eux

DIST_OUT=dist/tableau-server-password-validator
cp resources/index.html dist

browserify --extension=".coffee"  coffee/tableau-server-password-validator/app.coffee > ${DIST_OUT}.js
minify --output ${DIST_OUT}.min.js ${DIST_OUT}.js

