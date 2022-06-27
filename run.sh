#!/bin/bash
sudo chmod 666 /var/run/docker.sock
cd ./terraform
terraform init
terraform apply --auto-approve
cd ..
aws lambda invoke --function-name create_tables out.txt
sleep 5
cd ./data
aws s3 cp formula1_incomplete.sqlite s3://formula1-data/data.sqlite
sleep 30
aws s3 cp formula1.sqlite s3://formula1-data/data.sqlite
cd ..