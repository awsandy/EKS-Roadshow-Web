---
title: "Clean Up"
date: 2019-04-09T00:00:00-03:00
weight: 15
draft: false
---

### Cleaning up

To delete the resources used in this chapter:

```bash
kubectl delete -f ~/environment/run-my-nginx.yaml
kubectl delete ns my-nginx
rm ~/environment/run-my-nginx.yaml


