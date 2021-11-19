---
title: "Deploy & test a simple application"
date: 2018-08-07T13:36:57-07:00
weight: 41
---
#### Deploy a simple application:

Create a kubernetes deployment manifest using this command:

```bash
cat << EOF > app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: default
  name: deployment-2048
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: app-2048
  replicas: 1
  template:
    metadata:
      labels:
        app.kubernetes.io/name: app-2048
    spec:
      containers:
      - image: alexwhen/docker-2048
        imagePullPolicy: Always
        name: app-2048
        ports:
        - containerPort: 80
EOF
```

Lets look at some aspects of this manifest

* `kind: Deployment` tells Kubernetes this is a "deployment"
* `replicas: 1` asks the Kubernetes scheduler to run just one copy of our POD
* `-image: alexwhen/docker-2048`  tells us which docker image to download and run in the POD


Use kubectl to read and apply out application Manifest

```bash
kubectl apply -f app-deployment.yaml
```


Lets check things are ok:
Check the Kubernetes Deployment

```bash
kubectl get deployment
```
*You should see output similar to*
{{< output >}}
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
deployment-2048   1/1     1            1            3m
{{< /output >}}


Check the Kubernetes POD (our application in a container) is running
```bash
kubectl get pods
```
*You should see output similar to*
{{< output >}}
NAME                               READY   STATUS    RESTARTS   AGE
deployment-2048-79785cfdff-nksjp   1/1     Running   0          3m
{{< /output >}}

----

#### Test the application!

Enable port forwarding so we can see the application in our Cloud9 IDE:

```bash
kubectl port-forward $(kubectl get pods | grep deployment-2048 | cut -f1 -d' ') 8080:80
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



#### Congratulations!

You now have a fully working Amazon EKS Cluster with a working application.


----

#### Challenge:

* What can you change in the app-deployment.yaml file to run 3 replicas of the application rather than just one?
* How would you then "apply" the change?
* How would you then check that 3 pods are running?


----

#### Clean up the application


Interrupt the port forwarding with **ctrl-C**

And delete the deployment:

```bash
kubectl delete -f app-deployment.yaml
```


