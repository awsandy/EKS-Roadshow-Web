---
title: "Launch EKS"
date: 2018-08-07T13:34:24-07:00
weight: 20
---


{{% notice warning %}}
**DO NOT PROCEED** with this step unless you have [validated the IAM role](/020_prerequisites/workspaceiam/#validate-the-iam-role) in use by the Cloud9 IDE. You will not be able to run the necessary kubectl commands in the later modules unless the EKS cluster is built using the IAM role.
{{% /notice %}}

#### Challenge:

**How do I check the IAM role on the workspace?**

{{%expand "Expand here to see the solution" %}}
Run `aws sts get-caller-identity` and validate that your _Arn_ contains `eksworkshop-admin`and an Instance Id.

```output
{
    "Account": "xxxxxxxxxxxx",
    "UserId": "AROA1SAMPLEAWSIAMROLE:i-01234567890abcdef",
    "Arn": "arn:aws:sts::xxxxxxxxxxxx:assumed-role/eksworkshop-admin/i-01234567890abcdef"
}
```

If you do not see the correct role, please go back and [validate the IAM role](/020_prerequisites/workspaceiam/#validate-the-iam-role) for troubleshooting.

If you do see the correct role, proceed to next step to create an EKS cluster.
{{% /expand %}}

### Create an EKS cluster


Create an eksctl deployment file (eksworkshop.yaml) use in creating your cluster using the following syntax:

```bash
cat << EOF > eksworkshop.yaml
---
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: eksworkshop-eksctl
  region: ${AWS_REGION}
  version: "1.20"

availabilityZones: ["${AZS[0]}", "${AZS[1]}", "${AZS[2]}"]

managedNodeGroups:
- name: nodegroup
  desiredCapacity: 3
  instanceType: t3.small
  ssh:
    enableSsm: true

EOF

```

Next, use the file you created as the input for the eksctl cluster creation.

{{% notice info %}}
We are deliberatly launching at least one Kubernetes version behind the latest available on [Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html). This allows you to perform the [cluster upgrade](https://www.eksworkshop.com/intermediate/320_eks_upgrades/) lab.
{{% /notice %}}


#### Challenge:

**Launching EKS with some Production features**

Change eksworkshop.yaml to include one or more of the following:

* Full EKS logging to CloudWatch
* Include the latest add ons for coredns, kube-proxy & vpc-cni
* Enable OIDC
* Ensure the nodegroup uses private networking


{{% notice tip %}}
:bulb: You can find example code snippets to combine for all these suggested features at
https://github.com/weaveworks/eksctl/tree/main/examples
{{% /notice %}}



{{%expand "Expand here to see a possible solution" %}}
```bash
cat << EOF > eksworkshop.yaml
---
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: eksworkshop-eksctl
  region: ${AWS_REGION}
  version: "1.20"

availabilityZones: ["${AZS[0]}", "${AZS[1]}", "${AZS[2]}"]

managedNodeGroups:
- name: nodegroup
  desiredCapacity: 3
  instanceType: t3.small
  ssh:
    enableSsm: true
  privateNetworking: true

cloudWatch:
  clusterLogging:
    enableTypes: ["*"]
    # all supported types: "api", "audit", "authenticator", "controllerManager", "scheduler"
    # supported special values: "*" and "all"

iam:
  withOIDC: true

addons:
- name: vpc-cni # no version is specified so it deploys the default version
  attachPolicyARNs:
    - arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
- name: coredns
  version: latest # auto discovers the latest available
- name: kube-proxy
  version: latest

EOF
```

{{% /expand %}}

```bash
eksctl create cluster -f eksworkshop.yaml
```

*Note: Launching EKS and all the dependencies will take approximately 20 minutes*




