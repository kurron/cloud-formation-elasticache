#!/bin/bash

# creates a stack in AWS via CloudFromation

STACKNAME=${1:-Weapon-X-Cache}
PROJECTNAME=${2:-Weapon-X}
VPC=${3:-vpc-3db4d95a}
SUBNETS=${4:-subnet-f53ce2bc,subnet-77038710,subnet-b190a9e9}
ENVIRONMENT=${5:-development}
CREATOR=${6:-CloudFormation}
TEMPLATELOCATION=${7:-file://$(pwd)/elasticache.yml}

VALIDATE="aws cloudformation validate-template --template-body $TEMPLATELOCATION"
echo $VALIDATE
$VALIDATE

CREATE="aws cloudformation create-stack --stack-name $STACKNAME \
                                        --disable-rollback \
                                        --template-body $TEMPLATELOCATION \
                                        --capabilities CAPABILITY_NAMED_IAM \
                                        --parameters ParameterKey=Project,ParameterValue=$PROJECTNAME \
                                                     ParameterKey=Environment,ParameterValue=$ENVIRONMENT \
                                                     ParameterKey=Creator,ParameterValue=$CREATOR \
                                                     ParameterKey=Subnets,ParameterValue=\"$SUBNETS\" \
                                                     ParameterKey=VPC,ParameterValue=$VPC \
                                        --tags Key=Project,Value=$PROJECTNAME \
                                               Key=Environment,Value=$ENVIRONMENT \
                                               Key=Creator,Value=$CREATOR"
echo $CREATE
$CREATE
