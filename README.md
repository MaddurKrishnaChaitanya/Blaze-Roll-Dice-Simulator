# Roll-Dice-Simulation

# Design Architecture
![High Level Architecture Image](roll_dice_archirecture.png)

# Enhancements(TODO)
1. monitor lambda functions using CloudWatch Logs/Metrics
2. need to create resource for API Gateway in Terraform
3. need to make application code modularized by environment wise ex: sit,uat,prod..


# Pre-Requisites
1. Git
2. Python
3. Terraform
4. for AWS credentials create credentials file in below path  <br />
    Linux   ----- $HOME/.aws/credentials  <br />
    windows ----- %USERPROFILE%\.aws\credentials  <br />

# Execution Steps
1. clone the repo
2. go to terraform folder and run below commands <br />
     a) terraform init <br />
     b) terraform validate <br />
     c) terraform plan -var-file = var.tfvars   <br />
     d) terraform apply -var-file = var.tfvars  <br />
3. after step (d) terraform will provision API Gateway with 2 method resources, Dynamodb, permission roles and Lambda code deployment.
4. finally run terraform destroy -var-file = var.tfvars

# Resources
1. AWS (API Gateway(REST API), Lambda Function, DynamoDB, IAM Role)
2. Terraform
3. Boto3 

# AWS
1. created DynamoDb named ROLL_DICE_SIMULATION
2. created IAM Assume Role for Lambda function execution and attached inline policy to allow DynamoDb resource actions
3. created two lambda functions named RollDiceSumInsert and RollDiceDetails respectively
4. created REST API Gateway named Dice Distribution.  <br />
    a. [GET] [/rolldice] [Query Strings: totalrolls, sidesofdice, noofdice] will call RollDiceSumInsert lambda function
       and apply business logic, store data into DynamoDb  <br />
    b. [GET] [/rolldice/details] [Optional Query Strings: sidesofdice, noofdice] will call RollDiceDetails lambda function
       and apply business logic, return relative distribution  <br />

# Terraform
1. created terraform files to deploy the api gateway with 2 resource and will trigger event to lambda function into AWS.


# REST
1. Using API Gateway(REST) publish and deploy the resources to trigger lambda function
2. Using Authentication(API Keys or Token based) and Authorization(Policies) we can secure our API.
3. Using CloudWatch or any third party tools like Prometheus we can monitor our lambda functions
4. using automated CI/CD pipeline with different stages and steps like build, code review and e.t.c we will test quality of the API  

# DEMO URLS TO TEST(API Deployed at develop stage in My AWS Account)
 
 Case1:  <br />
 Simulation Total Insert <br />
 https://jp23513onj.execute-api.us-east-1.amazonaws.com/develop/rolldice?noofdice=1&sidesofdice=6&totalrolls=200 <br />
 
 Case2: <br />
 get relative distribution by dice no- dice side combination <br />
 https://jp23513onj.execute-api.us-east-1.amazonaws.com/develop/rolldice/details?noofdice=1&sidesofdice=6 <br />
 
 get total simulation and total rolls group by all dice no- dice side combination <br />
 https://jp23513onj.execute-api.us-east-1.amazonaws.com/develop/rolldice/details
 
 