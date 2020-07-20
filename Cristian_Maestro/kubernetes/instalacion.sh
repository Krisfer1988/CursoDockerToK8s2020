docker rmi $(docker images -q)
systemctl status docker
sudo vim /lib/systemd/system/docker.service
--exec-opt native.cgroupdriver=systemd en dockerd al arrancar servicio de docker
###
sudo systemctl daemon-reload
sudo swapoff -a
sudo vim /etc/fstab
###


# Pasos
# Paso 1: Alta del repo de kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update


# Paso 2: Instalar kubeadm
sudo apt-get install kubeadm -y
kubeadm version # comprobar la instalación

# Paso 3: Crear cluster con kubeadm
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

#Me salen del comando anterior estas 3 lineas
#Parra configurar mi usuarior
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  
#A  partir de lanzar la config anterior ya podemos ejecutar un kubectl  !!!


#Montar una red
#kubectl apply -f [podnetwork].yaml with one of the options listed at:
#https://kubernetes.io/docs/concepts/cluster-administration/addons/
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml


#Juntar nuevos nodos al cluster
kubeadm join 172.31.10.229:6443 --token yrwkpc.30jfcjt4f3aedh0t \
    --discovery-token-ca-cert-hash sha256:1303995500eae76b6539255b0af950aa8caca949ab1016361bc13427
    
    
kubectl get pods --all-namespaces
kubectl describe pod coredns-66bff467f8-fmvs7 -n kube-system

#Activaer autocompletado para kubernetes: 

source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.


kubectl apply -f apache_pod.yaml


# Para JUGAR y poder instalar cosas en el nodo maestro:
kubectl taint nodes --all node-role.kubernetes.io/master-
# EN PROD NOOOOOOO !!!!!!!!!


# Para acceder a un contenedor dentro de un pod.
kubectl exec -it podapache -c contenedorapache -- bash

#Para crear un configmap pasandol un archivo

kubectl create configmap configfilebeat2 --from-file=filebeat/filebeat.yml
