# Jelasticozor infrastructure

## Troubleshooting

### Connect to remote cluster

According to [this documentation](https://www.virtuozzo.com/application-platform-docs/kubernetes-cluster-access/), we can connect our k8s cluster just by running our `connect_cluster.sh` script. 

While that indeed makes it working to use `kubectl` and interact with the cluster, it is not sufficient to use with [Lens IDE](https://k8slens.dev/). 
That's probably because of the way the cluster user authenticates (with access token). To make it work with Lens, perform the following steps (as documented [here](https://www.cinqict.nl/blog/installing-a-kubernetes-cluster-and-connecting-it-to-lens)):

1. install the OpenVPN Access Server from the Jelastic Marketplace
2. install OpenVPN client on your computer
3. connect your VPN client to your VPN server
4. connect to your k8s cluster master node and display the `/root/.kube/config` file
5. take over the remote kube config and merge it with your local kube config
6. replace the `k8sm.env-8930174839.hidora.com` hostname with the k8sm node's ip address

Then, Lens will be able to connect to the remote k8s cluster. Alternatively, you can also

1. create a Jelastic endpoint to the master node on port 6443
2. connect to your k8s cluster master node and display the `/root/.kube/config` file
3. take over the remote kube config and merge it with your local kube config
4. replace the `k8sm.env-8930174839.hidora.com` hostname with the k8sm node's ip address