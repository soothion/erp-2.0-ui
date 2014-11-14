#! /bin/sh
grunt build
scp -r dist/index.html ds@ds.hisgadget.com:/var/www/erp/public/V1/
scp -r dist/scripts/* ds@ds.hisgadget.com:/var/www/erp/public/V1/scripts
scp -r dist/styles/* ds@ds.hisgadget.com:/var/www/erp/public/V1/styles
scp -r dist/views/* ds@ds.hisgadget.com:/var/www/erp/public/V1/views
