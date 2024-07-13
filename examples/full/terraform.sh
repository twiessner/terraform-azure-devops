#!/bin/bash

if [ -z "$1" ]; then
    echo "Please use ./terraform.sh command=[apply|plan|validate]"
    exit 1
fi

command=$(echo $1 | awk -F= '{print $2}')

terraform init

case $command in
    apply)
        echo "Apply changes ..."
        terraform apply
        ;;
    plan)
        echo "Plan changes..."
        terraform plan
        ;;
    destroy)
        echo "Destroy changes..."
        terraform destroy
        ;;
    validate)
        echo "Validate code..."
        terraform validate
        ;;
    *)
        echo "Wrong argument, please use ./terraform.sh command=[apply|plan|validate]"
        exit 1
        ;;
esac