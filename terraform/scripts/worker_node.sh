#!/bin/bash
chmod 400 default_my_key_pair.pem
chmod 400 /home/ec2-user/.ssh/id_rsa
export $1
export $2

#docker pre-reqs
sudo yum update -y
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
#enable br_netfilter for communication
sudo modprobe br_netfilter
sudo echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
#install docker
sudo yum install docker -y
sudo yum install git -y
sudo bash -c 'cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF'
sudo yum install tc -y
sudo systemctl daemon-reload
sudo systemctl enable docker --now
sudo service docker start

#install kubernetes
sudo bash -c "cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
   https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF"
sudo yum update -y
sudo yum install kubelet kubeadm kubectl -y
sudo systemctl enable kubelet
sudo bash -c "echo \"127.0.0.1 $(hostname)\" >> /etc/hosts"

hostnamectl set-hostname $NODE-$HOSTNAME
sudo aws s3 cp s3://$S3_BUCKET/kubernetes_join.txt kubernetes_join.txt
sudo $(cat kubernetes_join.txt)

#add swap memory
sudo dd if=/dev/zero of=/swapfile bs=1024 count=1048576 && \
sudo chmod 600 /swapfile && \
sudo mkswap /swapfile && \
echo '/swapfile            swap swap    0   0' >> /etc/fstab && \
sudo mount -a && \
sudo swapon -s && \
sudo swapon /swapfile && \
free -h
