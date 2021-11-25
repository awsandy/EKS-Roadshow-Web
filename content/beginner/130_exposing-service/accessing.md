---
title: "Accessing the Service"
date: 2019-04-09T00:00:00-03:00
weight: 11
draft: false
---

#### Accessing the Service

Kubernetes is able to find services using DNS.

DNS requires the [CoreDNS](https://kubernetes.io/docs/tasks/administer-cluster/coredns/#about-coredns) cluster add-on (this was automatically installed when creating the EKS cluster).


Let’s test the DNS name using a "curl" based application:

```bash
kubectl -n my-nginx run curl --image=radial/busyboxplus:curl -i --tty
```

Then, hit enter and run.

```bash
nslookup my-nginx
```

Output:
{{< output >}}
Server:    10.100.0.10
Address 1: 10.100.0.10 kube-dns.kube-system.svc.cluster.local

Name:      my-nginx
Address 1: 10.100.225.196 my-nginx.my-nginx.svc.cluster.local
{{< /output >}}

Type exit to log out of the container.

```bash
 exit
```
