import pulumi
import pulumi_aws as aws

size = "t2.micro"

ami = aws.ec2.get_ami(
    most_recent=True,
    owners=["amazon"],
    filters=[{"name": "name", "values": ["amzn2-ami-hvm-*"]}],
)

group = aws.ec2.SecurityGroup(
    "web-secgrp",
    description="Enable HTTP access",
    ingress=[
        {
            "protocol": "tcp",
            "from_port": 80,
            "to_port": 80,
            "cidr_blocks": ["0.0.0.0/0"],
        }
    ],
)

user_data = """
#!/bin/bash
echo "Hello, World!" > index.html
nohup python -m SimpleHTTPServer 80 &
"""

server = aws.ec2.Instance(
    "web-server-www",
    instance_type=size,
    vpc_security_group_ids=[group.id],
    user_data=user_data,
    ami=ami.id,
    tags={
        "Name": "test-webserver",
        "CostCenter": "Applications-In-Production",
    }
)

pulumi.export("public_ip", server.public_ip)
pulumi.export("public_dns", server.public_dns)