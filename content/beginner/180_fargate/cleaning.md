---
title: "Clean Up"
date: 2019-04-09T00:00:00-03:00
weight: 16
draft: false
---

### Cleaning up

To delete the resources used in this chapter:


Interrupt the port forwarding with **ctrl-C**

And delete the deployment:

```bash
kubectl delete -f app-deployment.yaml
```

```bash
eksctl delete fargateprofile \
  --name game-2048 \
  --cluster eksworkshop-eksctl
```
