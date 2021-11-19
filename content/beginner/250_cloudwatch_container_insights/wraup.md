---
title: "Wrapping Up"
chapter: false
weight: 12
---

#### Wrapping Up

As you can see it’s fairly easy to get CloudWatch Container Insights to work, and set alarms for CPU and other metrics.

With CloudWatch Container Insights we remove the need to manage and update your own monitoring infrastructure and allow you to use native AWS solutions that you don’t have to manage the platform for.

***

#### Cleanup your Environment

Let's clean up Wordpress so it's not running in your cluster any longer.

```bash
helm -n wordpress-cwi uninstall understood-zebu

kubectl delete namespace wordpress-cwi
```


## Thank you for using CloudWatch Container Insights!

{{% notice tip%}}
There is a lot more to learn about our Observability features using Amazon CloudWatch and AWS X-Ray. Take a look at our [One Observability Workshop](https://observability.workshop.aws)
{{% /notice%}}
