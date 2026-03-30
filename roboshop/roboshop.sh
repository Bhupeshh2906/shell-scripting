#!/bin/bash

AMI_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-0e7162c29a2e32f28"
INSTANCES=("Mongodb" "Redis" "Mysql" "rabbitmq" "catalogue" "shipping" "user" "cart" "payment" "dispatch" "frontend")
ZONE_ID="Z06617789DHVGKOPMYRA"
DOMAIN_NAME="projectprac.fun"

for instance in "${INSTANCES[@]}"
do
INSTANCE_ID=$(aws ec2 run-instances \
            --region us-east-1 \
            --image-id $AMI_ID \
            --instance-type t3.micro \
            --security-group-ids $SG_ID \
            --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
            --query "Instances[0].InstanceId" \
            --output text)

    if [ $instance != "frontend" ]
    then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text) 
        echo " instance $instance IP address is $IP."
        Record_name='$instance.$DOMAIN_NAME'
    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)
        echo " $instance ip address is $IP."
        Record_name='$DOMAIN_NAME'   
    fi

    aws route53 change-resource-record-sets \
  --hosted-zone-id $ZONE_ID \
  --change-batch '{
    "Comment": "Update record to reflect new IP address",
    "Changes": [
      {
        "Action": "UPSERT",
        "ResourceRecordSet": {
          "Name": "'$Record_name'",
          "Type": "A",
          "TTL": 1,
          "ResourceRecords": [
            {
              "Value": "$IP"
            }
          ]
        }
      }
    ]
  }'
done

