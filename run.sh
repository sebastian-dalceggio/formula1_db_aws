#!/bin/bash
cd ./terraform
terraform init
terraform apply --auto-approve
cd ../data
aws s3 mv formula1.sqlite s3://formula1.sqlite-test/data.sqlite