1. Once helm is set up and the code is pulled from the repo

2.Below commands can be executed

3.This package is for nginx application which runs on node port

helm lint project-mouse/
helm version
helm install --dry-run --debug ./project-mouse/ --generate-name
helm ls
helm install myproject ./project-mouse/
helm ls
kubectl get all 
kubectl get nodes -o wide

4. take a note of the nodes IP and note the node port details with <kubectl get svc>

5. Then in browser we can hit the containers via <ip:nodeport>
