# Goal

Connect to an instance in a Private subnet, a subnet with no Internet connection.

<img src="https://s.natalian.org/2022-06-26/ssm.png">

Warning: You probably need to tweak the security groups and you often need to
be patient for the Session Manager to offer a Connect button!

    aws ssm start-session --target $(terraform output -raw instance_id)

# Trouble shooting

https://aws.amazon.com/premiumsupport/knowledge-center/ec2-systems-manager-vpc-endpoints/

If the instance does not have Internet connectivity, i.e. ssm.region.amazonaws.com is unreachable, you must setup VPC endpoints.

# Makefile

You can use the Makefile as inspiration for overriding the S3 backend config.
