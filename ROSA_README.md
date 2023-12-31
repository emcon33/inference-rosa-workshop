
This is the OpenShift/ROSA version of an AI inference build out for an AI pipeline 
The purpose is to deploy an inference model into OpenShift/ROSA and setup the Ops management. 
We will also setup an ArgoCD pipeline to trigger an update from VS Code to Github to ROSA when changes are uploaded. 

currently the front end is not building so just use the backend. 

Deck: 

OpenShift/ROSA instructions (deck to be created) 
1. Build Image from github directly or use the 

Use OpenShift/ROSA to prebuild this image 
https://github.com/emcon33/emcon33-waiter/tree/main/backend

pre-built image 
docker.io/andrewwg/classification_model_serving

or CLI
oc new-project emcon33-waiter
oc run dog-inference --8000:80 andrewwg/classification_model_serving --port 5000
oc expose pod andrewwg/classification_model_serving --port 80 --target-port 5000 

2. Expose the application and Share via Console 
#Using GUI go to network and create route to the service: 
#get your API url (unique to your cluster) 

3. Collect the URL and Upload test image 
oc get svc
oc get ingresses.config/cluster -o jsonpath={.spec.domain}
#curl -X POST -F image=@test2.jpeg "http://0.0.0.0:8000/api/predict"

4. Set health checks etc. 
5. Create ArgoCD GitOps Pipeline and point to source backend image
6. Force updates or if you have clone the lab to your own, modify in VSCode and Commit changes to trigger an update. 
7. Each rebuild will upate the model available from ResNet18 

Example full URL
curl -X POST -F image=@dog.jpg 'http://classification_model_serving-default.apps.rosa-rrtdp.bmcz.p1.openshiftapps.com/predict'

#ArgoCD/Tekton Pipeline 
https://docs.openshift.com/container-platform/4.10/cicd/gitops/setting-up-argocd-instance.html


#### Todos
* Build Frontend (Gradio/Python version issue) 
* Port to Podman 
* Port to OpenShift/ROSA
* Rebuild as Workshop for AWS ROSA

### References
Original source https://towardsai.net/p/machine-learning/build-and-deploy-custom-docker-images-for-object-recognition
Forked from this github https://github.com/hasibzunair/imagercg-waiter