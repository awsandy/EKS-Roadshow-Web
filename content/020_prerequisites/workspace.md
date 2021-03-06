---
title: "Create a Workspace"
chapter: false
weight: 14
---


{{% notice info %}}
A list of supported browsers for AWS Cloud9 is found [here]( https://docs.aws.amazon.com/cloud9/latest/user-guide/browsers.html).
{{% /notice %}}


{{% notice tip %}}
Ad blockers, javascript disablers, and tracking blockers should be disabled for
the cloud9 domain, or connecting to the workspace might be impacted.
Cloud9 requires third-party-cookies. You can whitelist the [specific domains]( https://docs.aws.amazon.com/cloud9/latest/user-guide/troubleshooting.html#troubleshooting-env-loading).
{{% /notice %}}

### Launch Cloud9:

Create a Cloud9 Environment: [https://eu-west-1.console.aws.amazon.com/cloud9/home](https://eu-west-1.console.aws.amazon.com/cloud9/home)


- Select **Create environment**
- Name it **eksworkshop**, click Next.
- Choose **t3.small** for instance type, take all default values and click **Create environment**

When it comes up, customize the environment by:

- Closing the **Welcome tab**
![c9before](/images/prerequisites/cloud9-1.png)
- Opening a new **terminal** tab in the main work area
![c9newtab](/images/prerequisites/cloud9-2.png)
- Closing the lower work area
![c9newtab](/images/prerequisites/cloud9-3.png)
- Your workspace should now look like this
![c9after](/images/prerequisites/cloud9-4.png)

{{% notice info %}}
If you intend to run all the sections in this workshop, it will be useful to have more storage available for all the repositories and tests.
{{% /notice %}}

### Increase the disk size on the Cloud9 instance

{{% notice note %}}
The following command sequence adds more disk space to the root volume of the EC2 instance that Cloud9 runs on. 
{{% /notice %}}


```bash
# ------  resize OS disk -----------
# Specify the desired volume size in GiB as 32 GiB.
VOLUME_SIZE=${1:-32}

# Get the ID of the environment host Amazon EC2 instance.
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data//instance-id)

# Get the ID of the Amazon EBS volume associated with the instance.
VOLUME_ID=$(aws ec2 describe-instances \
  --instance-id $INSTANCE_ID \
  --query "Reservations[0].Instances[0].BlockDeviceMappings[0].Ebs.VolumeId" \
  --output text)

# Resize the EBS volume.
aws ec2 modify-volume --volume-id $VOLUME_ID --size $VOLUME_SIZE > /dev/null

# Wait for the resize to finish.
while [ \
  "$(aws ec2 describe-volumes-modifications \
    --volume-id $VOLUME_ID \
    --filters Name=modification-state,Values="optimizing","completed" \
    --query "length(VolumesModifications)"\
    --output text)" != "1" ]; do
sleep 1
done

if [ $(readlink -f /dev/xvda) = "/dev/xvda" ]
then
  # Rewrite the partition table so that the partition takes up all the space that it can.
  sudo growpart /dev/xvda 1
 
  # Expand the size of the file system.
  sudo resize2fs /dev/xvda1 > /dev/null

else
  # Rewrite the partition table so that the partition takes up all the space that it can.
  sudo growpart /dev/nvme0n1 1

  # Expand the size of the file system.
  # sudo resize2fs /dev/nvme0n1p1 #(Amazon Linux 1)
  sudo xfs_growfs /dev/nvme0n1p1 > /dev/null #(Amazon Linux 2)
fi
df -m /

```



