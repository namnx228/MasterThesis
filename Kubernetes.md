# Kubenetes termilogy:
+ Nodepod: local port in pod is exposed to a port of the node hosting this pod
+ Addons: Them cac tinh nang cho Kubernetes
+ Deployment: Launch a set of pods
+ ServiceAccount: a spec of each pod = username
    By Default: Default
+ Imperative vs Declarative management:
  - Imperative: Force object (create, replace, delete) to change extractly the same as what is written in the yaml file
  - Declarative: apply (apply, diff) change, keep the old if it is not changed.

+ External IP and Loadbalancer ?
  - Loadbalancer can get IP from cloud provider.
+ Exposing networking in Kubernetes like different ways --> Kube ---> pods

+ Ingress: Define a rule to foward and handle request
# Kubectl

    Main way to interact with cluster and manage application running on it.

```sh
  kubectl cluster-info
  kubectl get nodes
```

```sh
  kubectl create deployment first-deployment --image=katacoda/docker-http-server
  What is deployment and first-deployment ?
```

kubectl apply vs create
kubectl describe: more info about pod, service,...

kubectl get svc -l <the label>
  -l: the selector


# Minikube
Not use libvirt anymore ?
  Now: Each components in controlplane is container
# Question
KubeDNS ?
What at port 8443 ?: 
  Kube apiserver
What is kubectl ?
  Only connect to api server
  What is api server ?
    Only reply use http and json ?
      Authenticate ?
        Other version than v1 
          rbac.authiruzation.k8s.io/v1beta1
      Encryption ?
      What if this server is shutting down ?
      Can it be attack ?

What is pods expose ?
  What is svc ?
  What is cluster-IP ?
    when kubectl describe svc <depoyment name> -----> ClusterIP or IP
      What is this IP ?
  Which node the port is exposed to in multi-host ?

What is service ?
  A kind
  At least can be used to expose port
  Use selector to match the pods served by the service
What is default namespace ?
What pod will it expose using nodepod?
What

What is Coredns ?
What is CNI (Container Network I)?

ServiceAccount de lam gi ?
  Authenticate cai gi voi cai gi ?
  Token de lam gi ?
  Tai sao phai lam nhu vay ?
    How to set authenticate ?
Role and role binding ?

Dau la cai code cua cai dashboard ?
  In a image


Kind and kinder: Is it container inside other container ?
What is ingree ?

Neu thay cai labels for each pod to for deployment thi co duoc khong ?
  labels: for other part to discover and connect to the application

Soft multi-tenancy ?
What is the current status ?

Kubernetes a Proxy and DNS discovery ?


Note:
- Hien tai thi no Kubernetes khong that su multi-tenancy
    Cho du co namespace, co network policy
- Can rat nhieu effort de enforce cac policy de cho 1 new tenant.
- Chi tap trung vao 1 mang: storage, networking...
- Huong nua la quan tri Kurbenetes noi chung, hoac check cac tool, cac phuong thuc hien tai, roi propose 1 idea hoac review.
- Namespaced: What can go wrong ? pod can access the other pods in the same host ---> Kube network is flat (Access by everyone), memory leak, code injection, side channel attack.
  - NetworkPolicy: Admin can enforce NetworkPolicy, but what if tenant also want to use NetworkPolicy. Can tenant policy overwrite admin policy ?

Virtual cluster.
What is tenant CRD ?
  Tenant master vs super master
Sandbox containers ?
CNI ?

There is an ongoing effort in Kubernetes multi-tenancy working group, https://docs.google.com/document/d/1hpJX5O_siMmNGMvIHvz8Pm7XOjJLz5g57XWrgwWarFw, which is referred to as Namespace Group solutiono

DasmonSet ?
Virtual Cluster:
API level isolation ?
