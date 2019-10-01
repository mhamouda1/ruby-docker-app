#!/bin/bash
chmod 400 default_my_key_pair.pem
chmod 400 /home/ec2-user/.ssh/id_rsa
export $1

#add some swap memory
sudo dd if=/dev/zero of=/swapfile bs=1024 count=1048576 && \
sudo chmod 600 /swapfile && \
sudo mkswap /swapfile && \
echo '/swapfile            swap swap    0   0' >> /etc/fstab && \
sudo mount -a && \
sudo swapon -s && \
sudo swapon /swapfile && \
free -h

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
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors="NumCPU"

#make administration easier
sudo bash -c "echo \"alias kga='sudo kubectl get all'\"" >> ~/.bashrc && source ~/.bashrc
sudo bash -c "echo \"alias kgaan='sudo kubectl get all --all-namespaces'\"" >> ~/.bashrc && source ~/.bashrc
sudo bash -c "echo \"alias k='kubectl'\"" >> ~/.bashrc && source ~/.bashrc
sudo bash -c "echo \"alias kgn='kubectl get nodes'\"" >> ~/.bashrc && source ~/.bashrc
sudo bash -c "echo \"alias kgp='kubectl get pods'\"" >> ~/.bashrc && source ~/.bashrc
sudo bash -c "echo \"alias kgd='kubectl get deployments'\"" >> ~/.bashrc && source ~/.bashrc
sudo bash -c "echo \"alias kgs='kubectl get services'\"" >> ~/.bashrc && source ~/.bashrc
sudo bash -c "echo \"alias kgi='kubectl get ingresses'\"" >> ~/.bashrc && source ~/.bashrc
sudo bash -c "echo \"alias kgcm='kubectl get configmaps'\"" >> ~/.bashrc && source ~/.bashrc

#install vim and tmux dotfiles
yum install git -y && \
yum install tmux -y && \
yum install vim -y && \
git clone https://github.com/crowdtap/dotfiles ~/.dotfiles && \
cd ~/.dotfiles && \
echo '"Escape key' >> ~/.dotfiles/vimrc && \
echo ':imap jj <Esc>' >> ~/.dotfiles/vimrc && \
echo ':imap jk <Esc>'  >> ~/.dotfiles/vimrc && \
echo ':imap kj <Esc>'  >> ~/.dotfiles/vimrc && \
echo ':nmap Z :wa<CR>'  >> ~/.dotfiles/vimrc && \
echo "Bundle 'ervandew/screen'" >> ~/.custom.vim-plugins && \
./setup.sh && \
yum install the_silver_searcher -y


sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

sudo kubeadm token create --print-join-command --ttl=72h > kubernetes_join.txt

sudo aws s3 cp kubernetes_join.txt s3://$S3_BUCKET
hostnamectl set-hostname master
