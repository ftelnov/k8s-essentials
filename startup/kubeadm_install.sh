echo "Preparing to setup kubeadm. Let's take some checks"
[ -z "$(lsmod | grep br_netfilter)" ] && echo "Bridge netfilter is not loaded. Trying to modprobe it." && ((sudo modprobe br_netfilter && echo "Bridge netfilter is loaded with modprobe") || exit 1)

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

echo "Checks are finished. Moving to installation process. Updating repos.."
sudo apt-get update
echo "Repos are updated."

sudo apt-get install -y apt-transport-https ca-certificates curl
echo "Additional pre-packages are installed."

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
