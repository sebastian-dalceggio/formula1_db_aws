#!/bin/bash
sudo chmod 666 /var/run/docker.sock
cd ./terraform
terraform init
terraform apply --auto-approve
cd ../data
aws s3 cp formula1.sqlite s3://formula1-data/data.sqlite
cd ..
aws lambda invoke --function-name create_tables out.txt
# aws lambda delete-function --function-name create_tables