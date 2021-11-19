---
title: "Accessing the Service"
date: 2019-04-09T00:00:00-03:00
weight: 11
draft: false
---

#### Accessing the Service

Kubernetes is able to find services using DNS.

DNS requires the [CoreDNS](https://kubernetes.io/docs/tasks/administer-cluster/coredns/#about-coredns) cluster add-on (automatically installed when creating the EKS cluster).


To check if your cluster is already running CoreDNS, use the following command.

```bash
kubectl get service -n kube-system -l k8s-app=kube-dns
```

{{% notice note %}}
The service for CoreDNS is still called `kube-dns` for backward compatibility.
{{% /notice %}}


{{< output >}}
NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)         AGE
kube-dns   ClusterIP   10.0.0.10    <none>        53/UDP,53/TCP   8m
{{< /output >}}

If it isn’t running, you can enable it. The rest of this section will assume you have a Service with a long lived IP (my-nginx), and a DNS server that has assigned a name to that IP (the CoreDNS cluster add-on), so you can talk to the Service from any pod in your cluster using standard methods (e.g. gethostbyname). Let’s run another curl application to test this:

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
