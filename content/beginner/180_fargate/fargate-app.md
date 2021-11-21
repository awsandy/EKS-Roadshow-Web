---
title: "Deploy & test a simple application"
date: 2018-08-07T13:36:57-07:00
weight: 13
---
#### Deploy a simple application to fargate:

Create a Kubernetes Namespace `game-2048`

```bash
cat << EOF > f-app-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: game-2048
EOF
```

```bash
kubectl apply -f f-app-namespace.yaml
```
{{< output >}}
namespace/game-2048 created
{{< /output >}}


Our fargate profile is matched to the namespace `game-2048`.

Next create deployment that uses the `game-2048` namespace:

Create a kubernetes deployment manifest using this command:

```bash
cat << EOF > f-app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: game-2048
  name: fargate-deployment-2048
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: f-app-2048
  replicas: 1
  template:
    metadata:
      labels:
        app.kubernetes.io/name: f-app-2048
    spec:
      containers:
      - image: alexwhen/docker-2048
        imagePullPolicy: Always
        name: app-2048
        ports:
        - containerPort: 80
EOF
```


Use kubectl to read and apply our application Manifest

```bash
kubectl apply -f f-app-deployment.yaml
```


Lets check things are ok:
Check the Kubernetes Deployment

```bash
kubectl get deployment -n game-2048
```

*You should see output similar to*
{{< output >}}
NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
fargate-deployment-2048   1/1     1            1           2m42s
{{< /output >}}


Check the Kubernetes POD (our application in a container) is running
```bash
kubectl get pods -n game-2048
```
*You should see output similar to*
{{< output >}}
NAME                                       READY   STATUS    RESTARTS   AGE
fargate-deployment-2048-79bccd9c8d-9nf6h   1/1     Running   0          4m4s
{{< /output >}}


Next lets conform put app is running in Fargate:

```bash
kubectl get nodes
```

{{< output >}}
NAME                                                    STATUS   ROLES    AGE     VERSION
fargate-ip-192-168-100-199.eu-west-1.compute.internal   Ready    <none>   8m59s   v1.20.7-eks-135321
ip-192-168-106-17.eu-west-1.compute.internal            Ready    <none>   41h     v1.20.11-eks-f17b81
ip-192-168-156-186.eu-west-1.compute.internal           Ready    <none>   41h     v1.20.11-eks-f17b81
ip-192-168-190-236.eu-west-1.compute.internal           Ready    <none>   41h     v1.20.11-eks-f17b81
{{< /output >}}


If your cluster has any worker nodes, they will be listed with a name starting wit the `ip-` prefix.

In addition to the worker nodes, if any, there will now be additional `fargate-` nodes listed. 

These are merely kubelets from the microVMs in which your sample app pods are running under Fargate, posing as nodes to the EKS Control Plane. 

This is how the EKS Control Plane stays aware of the Fargate infrastructure under which the pods it orchestrates are running. 

There will be a “fargate” node added to the cluster for each pod deployed on Fargate.

----

#### Test the application!

Enable port forwarding so we can see the application in our Cloud9 IDE:

```bash
kubectl port-forward $(kubectl get pods -n game-2048 | grep fargate-deployment-2048 | cut -f1 -d' ') 8080:80 -n game-2048
```

{{< output >}}
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
Handling connection for 8080
Handling connection for 8080
{{< /output >}}

Preview the running (port-forwarded service) application from the cloud 9 IDE"

`Preview` -> `Preview Running Application`
![tf-state](/images/andyt/game-2048-0.jpg)

You should then see the app running in the browser 

![tf-state](/images/andyt/game-2048-1.jpg)


#### Challenge:

* What can you change in the app-deployment.yaml file to run 3 replicas of the application rather than just one?
* How would you then "apply" the change?
* How would you then check that 3 pods are running?

----




