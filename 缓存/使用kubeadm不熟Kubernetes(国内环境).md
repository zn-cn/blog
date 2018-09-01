# 使用kubeadm 部署 Kubernetes(国内环境)

其他方案选择：

+ 不用工具，从零开始，请参考：[和我一步步部署 kubernetes 集群](https://github.com/opsnull/follow-me-install-kubernetes-cluster)
+ 若只是在单机上体验，可以使用Minikbe，请参考：[官方 Install Mikikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)

官网: https://kubernetes.io/

Vagrant：若想在本地测试可通过 vagrant 创建虚拟机模拟集群测试，见附录

官方教程：https://kubernetes.io/docs/setup/independent/install-kubeadm/

**此处未采用官方教程（需要翻墙），这里仅介绍国内环境安装详细过程**

注：如若没有注明，则默认采用 Ubuntu16.04 +环境

测试时候版本为当时最新版：

+ kubernetesv1.11.2

## 服务器配置要求

注：最好所有机器在同一区，这样可以使用内网互通

- 操作系统要求
  - Ubuntu 16.04+
  - Debian 9
  - CentOS 7
  - RHEL 7
  - Fedora 25/26 (best-effort)
  - HypriotOS v1.0.1+
  - Container Linux (tested with 1800.6.0)
- 2+ GB RAM
- 2+ CPUs
- 所有机器之间通信正常
- 唯一的hostname, MAC address, and product_uuid
- 特定的端口开放（安全组和防火墙未将其排除在外）
- 关闭Swap交换分区

## 安装 Docker

### Ubuntu

```shell
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh --mirror Aliyun
```

启动 Docker CE

```
sudo systemctl enable docker
sudo systemctl start docker
```

建立 docker 用户组

建立 `docker` 组：

```
sudo groupadd docker
```

将当前用户加入 `docker` 组：

```
sudo usermod -aG docker $USER
```

镜像加速：

对于使用 [systemd](https://www.freedesktop.org/wiki/Software/systemd/) 的系统，请在 `/etc/docker/daemon.json` 中写入如下内容（如果文件不存在请新建该文件）

注：若平常使用阿里云镜像较为频繁，推荐使用阿里云镜像加速，这里以 Docker 官方加速器 为例

```
{
  "registry-mirrors": [
    "https://registry.docker-cn.com"
  ]
}
```

之后重新启动服务

```
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## 禁用 swap

> 对于禁用`swap`内存，具体原因可以查看Github上的Issue：[Kubelet/Kubernetes should work with Swap Enabled](https://github.com/kubernetes/kubernetes/issues/53533)

+ 编辑`/etc/fstab`文件，注释掉引用`swap`的行
+ `sudo swapoff -a`
+ 测试：输入`top` 命令，若 KiB Swap一行中 total 显示 0 则关闭成功

> 若想永久关闭：
>
> + sudo vim /etc/fstab
>
>   注释掉swap那一行
>
> + 重启

## 安装 kubeadm, kubelet and kubectl

权限：root

shell: bash

### centos

centos 使用阿里云的源，但是更新不如 中科大的

```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
        http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

setenforce 0
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable kubelet && systemctl start kubelet
```

### ubuntu

使用 中科大 的源

```
apt-get update && apt-get install -y apt-transport-https curl
curl -s http://packages.faasx.com/google/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://mirrors.ustc.edu.cn/kubernetes/apt kubernetes-xenial main
EOF

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
```

## 其他前置配置

### 在Master节点中配置 cgroup driver

查看 Docker 使用 cgroup driver:

```
docker info | grep -i cgroup
-> Cgroup Driver: cgroupfs
```

而 kubelet 使用的 cgroupfs 为system，不一致故有如下修正：

`sudo vim /etc/systemd/system/kubelet.service.d/10-kubeadm.conf`

加上如下配置：

```
Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"
```

或者

```
Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1"
```

重启 kubelet

```
systemctl daemon-reload
systemctl restart kubelet
```

### 解除防火墙限制

`vim /etc/sysctl.conf`

```
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
```

接着

```
sysctl -p
```

## 安装镜像

Master 和 Node 启动的核心服务分别如下：

| Master 节点                      | Node 节点                        |
| -------------------------------- | -------------------------------- |
| etcd-master                      | Control plane(如：calico,fannel) |
| kube-apiserver                   | kube-proxy                       |
| kube-controller-manager          | other apps                       |
| kube-dns                         |                                  |
| Control plane(如：calico,fannel) |                                  |
| kube-proxy                       |                                  |
| kube-scheduler                   |                                  |

使用如下命令：

```
kubeadm config images list
```

获取当前版本kubeadm 启动需要的镜像，示例如下：

```
k8s.gcr.io/kube-apiserver-amd64:v1.11.2
k8s.gcr.io/kube-controller-manager-amd64:v1.11.2
k8s.gcr.io/kube-scheduler-amd64:v1.11.2
k8s.gcr.io/kube-proxy-amd64:v1.11.2
k8s.gcr.io/pause:3.1
k8s.gcr.io/etcd-amd64:3.2.18
k8s.gcr.io/coredns:1.1.3
```

使用如下脚本：

> 亦可提前在本地下载好，之后打包成tar，再直接传到服务器上导入即可

可从阿里云的镜像替换为谷歌的镜像

```
#!/bin/bash
images=(
    kube-apiserver-amd64:v1.11.2
    kube-controller-manager-amd64:v1.11.2
    kube-scheduler-amd64:v1.11.2
    kube-proxy-amd64:v1.11.2
    pause:3.1
    etcd-amd64:3.2.18
    coredns:1.1.3

    pause-amd64:3.1

    kubernetes-dashboard-amd64:v1.10.0
    heapster-amd64:v1.5.4
    heapster-grafana-amd64:v5.0.4
    heapster-influxdb-amd64:v1.5.2
)

for imageName in ${images[@]} ; do
    docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
    docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
done
```

> 关于如何自建拉去国外镜像，可借助Docker Hub或者阿里云的容器镜像服务。
>
> 简单步骤如下：
>
> + 建立一个github仓库，其中一个文件内容如下：
>
>   etcd-amd64/Dockerfile
>
>   ```
>   FROM gcr.io/google_containers/etcd-amd64:3.2.18
>   LABEL maintainer="yun_tofar@qq.com"
>   LABEL version="1.0"
>   LABEL description="kubernetes"
>   ```
>
> + 之后在镜像仓库中建立 auto build 类型的仓库，自动追踪github变动，更新镜像
>
> 具体步骤请自行查询，不是本文重点

## 检查端口是否被占用

### Master 节点

| Protocol | Direction | Port Range | Purpose                 | Used By              |
| -------- | --------- | ---------- | ----------------------- | -------------------- |
| TCP      | Inbound   | 6443*      | Kubernetes API server   | All                  |
| TCP      | Inbound   | 2379-2380  | etcd server client API  | kube-apiserver, etcd |
| TCP      | Inbound   | 10250      | Kubelet API             | Self, Control plane  |
| TCP      | Inbound   | 10251      | kube-scheduler          | Self                 |
| TCP      | Inbound   | 10252      | kube-controller-manager | Self                 |

### Worker节点

| Protocol | Direction | Port Range  | Purpose             | Used By             |
| -------- | --------- | ----------- | ------------------- | ------------------- |
| TCP      | Inbound   | 10250       | Kubelet API         | Self, Control plane |
| TCP      | Inbound   | 30000-32767 | NodePort Services** | All                 |

## 初始化 kubeadm

```
sudo kubeadm init --kubernetes-version=v1.11.2 --apiserver-advertise-address=<your ip> --pod-network-cidr=192.168.0.0/16
```

init 常用主要参数：

- --kubernetes-version: 指定Kubenetes版本，如果不指定该参数，会从google网站下载最新的版本信息。
- --pod-network-cidr: 指定pod网络的IP地址范围，它的值取决于你在下一步选择的哪个网络网络插件，比如我在本文中使用的是Calico网络，需要指定为`192.168.0.0/16`。
- --apiserver-advertise-address: 指定master服务发布的Ip地址，如果不指定，则会自动检测网络接口，通常是内网IP。
- --feature-gates=CoreDNS: 是否使用CoreDNS，值为true/false，CoreDNS插件在1.10中提升到了Beta阶段，最终会成为Kubernetes的缺省选项。

```
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

测试：

`curl https://127.0.0.1:6443 -k` 或者 `curl https://<master-ip>:6443 -k`

回应如下：

```
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {

  },
  "status": "Failure",
  "message": "forbidden: User \"system:anonymous\" cannot get path \"/\"",
  "reason": "Forbidden",
  "details": {

  },
  "code": 403
}
```

## 安装网络插件 - Calico

安装镜像：

```
docker pull quay.io/calico/node:v3.1.3
docker pull quay.io/calico/cni:v3.1.3
docker pull quay.io/calico/typha:v0.7.4
```

这里采用 Calico，更多请看[官方介绍](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/)，自行查询不同插件区别

```
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
```

> 为了Calico可以正常运行，必须在执行kubeadm init时使用 `--pod-network-cidr=192.168.0.0/16`

网络插件安装完成后，可以通过检查`coredns pod`的运行状态来判断网络插件是否正常运行：

```
kubectl get pods --all-namespaces

# 输出如下：
# 注：coredns 启动需要一定时间，刚开始是Pending
NAMESPACE     NAME                                   READY     STATUS              RESTARTS   AGE
kube-system   calico-node-lxz4c                      0/2       ContainerCreating   0          4m
kube-system   coredns-78fcdf6894-7xwn7               0/1       Pending             0          5m
kube-system   coredns-78fcdf6894-c2pq8               0/1       Pending             0          5m
kube-system   etcd-iz948lz3o7sz                      1/1       Running             0          5m
kube-system   kube-apiserver-iz948lz3o7sz            1/1       Running             0          5m
kube-system   kube-controller-manager-iz948lz3o7sz   1/1       Running             0          5m
kube-system   kube-proxy-wcj2r                       1/1       Running             0          5m
kube-system   kube-scheduler-iz948lz3o7sz            1/1       Running             0          4m

```

> 若你的STATUS全部为Pending，则说明你的pause-amd64镜像由于墙的原因没有拉下来，故本文在脚本中已经通过国内镜像先行拉下来了(kubeadm 启动需要的是pause镜像)

等待`coredns pod`的状态变成**Running**，就可以继续添加从节点了

### 加入其他节点

> 默认情况下由于安全原因你的cluster不会调度pods在你的master上。如果你想让你的master也参与调度，run:
>
> ```
> kubectl taint nodes --all node-role.kubernetes.io/master-
> ```
>
> 或者
>
> ```
> kubectl taint nodes k8s-node1 node-role.kubernetes.io/master-
> ```
>
> 可能会有类似如下输出：
>
> ```
> node "test-01" untainted
> taint "node-role.kubernetes.io/master:" not found
> taint "node-role.kubernetes.io/master:" not found
> ```
>
> 它将会在那些有它的节点移除 `node-role.kubernetes.io/master` 污染，包括master 节点, 所以之后将可以在任意一个地方调度

```
kubeadm join --token <token> <master-ip>:<master-port> --discovery-token-ca-cert-hash sha256:<hash>
```

几秒后，你在主节点上运行`kubectl get nodes`就可以看到新加的机器了：

```
NAME             STATUS    ROLES     AGE       VERSION
centos   Ready     master    13m        v1.11.2
ubuntu          Ready     <none>    13m        v1.11.2
```

## 安装可视化 Dashboard UI

官方教程：https://github.com/kubernetes/dashboard/wiki/Installation

预备镜像：

```
k8s.gcr.io/kubernetes-dashboard-amd64:v1.8.3

# 下面为插件的镜像
k8s.gcr.io/heapster-amd64:v1.5.4
k8s.gcr.io/heapster-grafana-amd64:v5.0.4
k8s.gcr.io/heapster-influxdb-amd64:v1.5.2
```

推荐：

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
```

自定义：

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/alternative/kubernetes-dashboard.yaml
```

配置 可视化接口

```
kubectl -n kube-system edit service kubernetes-dashboard
# 编辑内容如下：
  ports:
  - nodePort: 32576
    port: 443
    protocol: TCP
    targetPort: 8443
  type: NodePort
```

查询

```
kubectl -n kube-system get service kubernetes-dashboard
```

### 配置admin

vim kubernetes-dashboard-admin.yaml

```
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-admin
  namespace: kube-system

---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard-admin
  labels:
    k8s-app: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard-admin
  namespace: kube-system
```

之后：`kubectl create -f kubernetes-dashboard-admin.yml`

### 登录

![ç»éçé¢](https://jimmysong.io/kubernetes-handbook/images/kubernetes-dashboard-1.7.1-login.jpg)

#### Kubeconfig登录

注：auth 模式不推荐使用

##### 创建 admin 用户

file: admin-role.yaml

```
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: admin
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
subjects:
- kind: ServiceAccount
  name: admin
  namespace: kube-system
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin
  namespace: kube-system
  labels:
    kubernetes.io/cluster-service: "true"
    addonmanager.kubernetes.io/mode: Reconcile
```

`kubectl create -f admin-role.yaml`

#### 获取token

```
kubectl -n kube-system get secret|grep admin-token
->  admin-token-tdvfz                                kubernetes.io/service-account-token   3         5s

kubectl -n kube-system describe secret admin-token-tdvfz
```

设置 Kubeconfig文件

```
copy ~/.kube/config /path/to/Kubeconfig
vim Kubeconfig
# 将上文中获取的token加入其中
```

大约如下：

![kubeconfigæä»¶](https://jimmysong.io/kubernetes-handbook/images/brand-kubeconfig-yaml.jpg)

#### Token登录

获取token:

```
kubectl -n kube-system describe $(kubectl -n kube-system get secret -n kube-system -o name | grep namespace) | grep token
```

获取admin-token:

```
kubectl -n kube-system describe secret/$(kubectl -n kube-system get secret | grep kubernetes-dashboard-admin | awk '{print $1}') | grep token

```

若以默认身份登录可能如下：

![é¦é¡µ](https://jimmysong.io/kubernetes-handbook/images/kubernetes-dashboard-1.7.1-default-page.jpg)

### 集成 heapster

**注：Kubernetes默认master是不参与 pod分配资源的，和正常情况下heapster 需要安装在node节点上，如果你只有master或许无法启动成功**

安装 heapster

```
mkdir heapster
cd heapster
wget https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/grafana.yaml
wget https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
wget https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
wget https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml

```

之后修改 heapster.yaml

```
--source=kubernetes:https://10.209.3.82:6443   --------改成自己的ip
--sink=influxdb:http://monitoring-influxdb.kube-system.svc:8086

```

或者

```
--source=-source=kubernetes.summary_api:https://kubernetes.default.svc?inClusterConfig=false&kubeletHttps=true&kubeletPort=10250&insecure=true&auth=
--sink=influxdb:http://monitoring-influxdb.kube-system.svc:8086
```



修改所有文件 image 为 `registry.cn-hangzhou.aliyuncs.com/google_containers/`

如：`k8s.gcr.io/heapster-grafana-amd64:v5.0.4` -> `registry.cn-hangzhou.aliyuncs.com/google_containers/heapster-grafana-amd64:v5.0.4`

> 使用 kubernetes ClusterIP也是可以的
>
> `kubectl get service`
>
> NAME             TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
> kubernetes       ClusterIP   10.0.0.1     <none>        443/TCP        1d
>
> 修改 heapster.yaml
>
> command:
>     - /heapster
>     - --source=kubernetes:https://10.0.0.1
>     - --sink=influxdb:http://monitoring-influxdb.kube-system.svc:8086

之后创建

```
kubectl create -f ./


```

结果如下：

![img](https://github.com/kubernetes/dashboard/raw/master/docs/dashboard-ui.png)

![å®æ¹ç¨ä¾](http://leonlibraries.github.io/2017/06/15/Kubeadm%E6%90%AD%E5%BB%BAKubernetes%E9%9B%86%E7%BE%A4/demo.jpeg)

## 官方用例部署

[Sock Shop](https://microservices-demo.github.io/)

官方演示了一个袜子商城，以微服务的形式部署起来

```
kubectl create namespace sock-shop

kubectl apply -n sock-shop -f "https://github.com/microservices-demo/microservices-demo/blob/master/deploy/kubernetes/complete-demo.yaml?raw=true"
```

同样，等待 Pod 变为 Running 状态，便安装成功
[![官方用例](http://leonlibraries.github.io/2017/06/15/Kubeadm%E6%90%AD%E5%BB%BAKubernetes%E9%9B%86%E7%BE%A4/demo.jpeg)](http://leonlibraries.github.io/2017/06/15/Kubeadm%E6%90%AD%E5%BB%BAKubernetes%E9%9B%86%E7%BE%A4/demo.jpeg)官方用例

我们可以看到这个商城拆分成了许多微服务模块，支付、用户、订单以及购物车等等。我们接下来访问一下他的前端，如果功能能通，就说明跨主机网络访问是能跑通的。

我们可以看到 front-end 模块绑定的 nodePort 是 30001

查看前端服务开放端口命令：`kubectl -n sock-shop get svc front-end`

[![img](http://leonlibraries.github.io/2017/06/15/Kubeadm%E6%90%AD%E5%BB%BAKubernetes%E9%9B%86%E7%BE%A4/nodeport.jpeg)](http://leonlibraries.github.io/2017/06/15/Kubeadm%E6%90%AD%E5%BB%BAKubernetes%E9%9B%86%E7%BE%A4/nodeport.jpeg)

访问 [http://192.168.80.25:30001](http://192.168.80.25:30001/) 即可看到如下画面
[![img](http://leonlibraries.github.io/2017/06/15/Kubeadm%E6%90%AD%E5%BB%BAKubernetes%E9%9B%86%E7%BE%A4/sockshop.jpeg)](http://leonlibraries.github.io/2017/06/15/Kubeadm%E6%90%AD%E5%BB%BAKubernetes%E9%9B%86%E7%BE%A4/sockshop.jpeg)

如果加购物车功能能够跑通，就说明集群搭建成功，没毛病。

卸载 socks shop: `kubectl delete namespace sock-shop`

## 附录：

### 使用vagrant 在本地模拟集群

主机环境为：Ubuntu 16.04 LTS，从 [官方站点](https://link.jianshu.com?t=https%3A%2F%2Fwww.vagrantup.com%2Fdownloads.html) 下载最新版本 vagrant 并安装到系统。

```
sudo dpkg -i vagrant_2.1.2_x86_64.deb
sudo apt install virtualbox # 若安装失败，多半是Linux内核缺少了header,手动安装即可
```

下载 带有docker 的 ubuntu box

```
vagrant box add comiq/dockerbox
```

或者 手动在[官方](vagrant box add ubuntu-xenial-docker file:///d:/path/to/file.box)下载之后

```
vagrant box add ubuntu-xenial-docker /path/to/file.box
```

使用配置文件启动虚拟机：

文件：Vagrantfile

相关参数介绍：

+ config.vm.define 后面是名字
+ v.customize 里面有内存相关的参数
+ node.vm.box 表明使用的box
+ node.vm.hostname hostname
+ node.vm.synced_folder 共享目录

```
Vagrant.configure("2") do |config|

	(1..2).each do |i|

		config.vm.define "node#{i}" do |node|

		# 设置虚拟机的Box
		node.vm.box = "comiq/dockerbox"

		# 设置虚拟机的主机名
		node.vm.hostname="node#{i}"

		# 设置虚拟机的IP
		node.vm.network "private_network", ip: "192.168.59.#{i}"

		# 设置主机与虚拟机的共享目录
		node.vm.synced_folder "~/公共的", "/home/vagrant/share"

		# VirtaulBox相关配置
		node.vm.provider "virtualbox" do |v|

			# 设置虚拟机的名称
			v.name = "node#{i}"

			# 设置虚拟机的内存大小  
			v.memory = 1200

			# 设置虚拟机的CPU个数
			v.cpus = 1
		end

		end
	end
end
```

> 注：bridge 请自行修改，修改方法如下：
>
> 输入：`ifconfig -a`
>
> 找到 inet 地址以 192.168 开头的网卡，示例如下：
>
> ```
> docker_gwbridge Link encap:以太网  硬件地址 02:42:b6:f5:a0:ec
>           inet 地址:172.19.0.1  广播:172.19.255.255  掩码:255.255.0.0
>           inet6 地址: fe80::42:b6ff:fef5:a0ec/64 Scope:Link
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  跃点数:1
>           接收数据包:0 错误:0 丢弃:0 过载:0 帧数:0
>           发送数据包:106 错误:0 丢弃:0 过载:0 载波:0
>           碰撞:0 发送队列长度:0
>           接收字节:0 (0.0 B)  发送字节:15373 (15.3 KB)
>
> enp2s0    Link encap:以太网  硬件地址 50:7b:9d:d2:66:0b
>           UP BROADCAST MULTICAST  MTU:1500  跃点数:1
>           接收数据包:0 错误:0 丢弃:0 过载:0 帧数:0
>           发送数据包:0 错误:0 丢弃:0 过载:0 载波:0
>           碰撞:0 发送队列长度:1000
>           接收字节:0 (0.0 B)  发送字节:0 (0.0 B)
>
> lo        Link encap:本地环回
>           inet 地址:127.0.0.1  掩码:255.0.0.0
>           inet6 地址: ::1/128 Scope:Host
>           UP LOOPBACK RUNNING  MTU:65536  跃点数:1
>           接收数据包:18329 错误:0 丢弃:0 过载:0 帧数:0
>           发送数据包:18329 错误:0 丢弃:0 过载:0 载波:0
>           碰撞:0 发送队列长度:1000
>           接收字节:29306778 (29.3 MB)  发送字节:29306778 (29.3 MB)
>
> wlp4s0    Link encap:以太网  硬件地址 44:1c:a8:24:85:1b
>           inet 地址:192.168.3.136  广播:192.168.3.255  掩码:255.255.255.0
>           inet6 地址: fe80::18fa:30be:13b4:1650/64 Scope:Link
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  跃点数:1
>           接收数据包:25397 错误:0 丢弃:0 过载:0 帧数:0
>           发送数据包:15529 错误:0 丢弃:0 过载:0 载波:0
>           碰撞:0 发送队列长度:1000
>           接收字节:34579781 (34.5 MB)  发送字节:1990407 (1.9 MB)
>
> ```

首次启动：

```
mkdir vagrant
cd vagrant
cp /path/to/vagrantfile Vagrantfile
vagrant up
```

以后启动只需在相关目录下：`vagrant up`

进入 box: `vagrant ssh <box define name>` ，如：`vagrant ssh master`

关机：`vagrant halt`

### docker 导出镜像与打包

```
docker save quay.io/calico/cni > calico_cni.tar
docker load < calico_cni.tar
```

### 重建

及其危险，请谨慎使用

```
sudo kubeadm reset
```

### 转换 docker-compose 为 Kubernetes Resources

#### 安装 Kompose

##### Github release

 [GitHub release page](https://github.com/kubernetes/kompose/releases).

```
# Linux 
curl -L https://github.com/kubernetes/kompose/releases/download/v1.1.0/kompose-linux-amd64 -o kompose

# macOS
curl -L https://github.com/kubernetes/kompose/releases/download/v1.1.0/kompose-darwin-amd64 -o kompose

# Windows
curl -L https://github.com/kubernetes/kompose/releases/download/v1.1.0/kompose-windows-amd64.exe -o kompose.exe

chmod +x kompose
sudo mv ./kompose /usr/local/bin/kompose
```

##### Go

Installing using `go get` pulls from the master branch with the latest development changes.

```
go get -u github.com/kubernetes/kompose
```

#### [Use Kompose](https://kubernetes.io/docs/tasks/configure-pod-container/translate-compose-kubernetes/#use-kompose)

1. docker-compose.yml

   ```
     version: "2"

     services:

       redis-master:
         image: k8s.gcr.io/redis:e2e 
         ports:
           - "6379"

       redis-slave:
         image: gcr.io/google_samples/gb-redisslave:v1
         ports:
           - "6379"
         environment:
           - GET_HOSTS_FROM=dns

       frontend:
         image: gcr.io/google-samples/gb-frontend:v4
         ports:
           - "80:80"
         environment:
           - GET_HOSTS_FROM=dns
         labels:
           kompose.service.type: LoadBalancer
   ```

2. Run the `kompose up` command to deploy to Kubernetes directly, or skip to the next step instead to generate a file to use with `kubectl`.

   ```
     $ kompose up
     We are going to create Kubernetes Deployments, Services and PersistentVolumeClaims for your Dockerized application. 
     If you need different kind of resources, use the 'kompose convert' and 'kubectl create -f' commands instead. 

     INFO Successfully created Service: redis          
     INFO Successfully created Service: web            
     INFO Successfully created Deployment: redis       
     INFO Successfully created Deployment: web         

     Your application has been deployed to Kubernetes. You can run 'kubectl get deployment,svc,pods,pvc' for details.
   ```

3. To convert the `docker-compose.yml` file to files that you can use with `kubectl`, run `kompose convert` and then `kubectl create -f <output file>`.

   ```
     $ kompose convert                           
     INFO Kubernetes file "frontend-service.yaml" created         
     INFO Kubernetes file "redis-master-service.yaml" created     
     INFO Kubernetes file "redis-slave-service.yaml" created      
     INFO Kubernetes file "frontend-deployment.yaml" created      
     INFO Kubernetes file "redis-master-deployment.yaml" created  
     INFO Kubernetes file "redis-slave-deployment.yaml" created   
   ```

   ```
     $ kubectl create -f frontend-service.yaml,redis-master-service.yaml,redis-slave-service.yaml,frontend-deployment.yaml,redis-master-deployment.yaml,redis-slave-deployment.yaml
     service "frontend" created
     service "redis-master" created
     service "redis-slave" created
     deployment "frontend" created
     deployment "redis-master" created
     deployment "redis-slave" created
   ```

   Your deployments are running in Kubernetes.

4. Access your application.

   If you’re already using `minikube` for your development process:

   ```
     $ minikube service frontend
   ```

   Otherwise, let’s look up what IP your service is using!

   ```
     $ kubectl describe svc frontend
     Name:                   frontend
     Namespace:              default
     Labels:                 service=frontend
     Selector:               service=frontend
     Type:                   LoadBalancer
     IP:                     10.0.0.183
     LoadBalancer Ingress:   123.45.67.89
     Port:                   80      80/TCP
     NodePort:               80      31144/TCP
     Endpoints:              172.17.0.4:80
     Session Affinity:       None
     No events.
   ```

   If you’re using a cloud provider, your IP will be listed next to `LoadBalancer Ingress`.

   ```
     $ curl http://123.45.67.89
   ```

### 镜像查询

直接查看相关的yaml中image参数

### 最佳实践

https://kubernetes.io/docs/concepts/configuration/overview/