# inference-rosa-workshop
# This is a workshop for deploying a Pytorch & FastAPI project to ROSA on AWS and perform inference.
by Andrew Grimes and Jim Garrett of Red Hat 

Containerized app that serves a containerized Resnet18 deep learning image classification model using FastAPI. We used an ImageNet pretrained model that can predict 1000 different classes of general objects, the samples are animals but it will work with anything. See class list [here](https://deeplearning.cms.waikato.ac.nz/user-guide/class-maps/IMAGENET/).

Forked from this project for a workshop: https://github.com/hasibzunair/imagercg-waiter
ResNet18 https://www.mathworks.com/help/deeplearning/ref/resnet18.html

A second option is to add a Gradio web front end to this probject. Here is the git repo for the web front end option. 
https://github.com/emcon33/inference-rosa-frontend

#### Todos
* Port to Podman 
* Add ArgoCD GitOps Pipeline deployment option 

Sample Backend App and Input Image: 
<p align="left">
  <a href="#"><img src="./sample.jpg" width="600"></a> <br />
  <em> 
  </em>
</p>

Sample Text Output:
{"success":true,"predictions":[{"label":"black-and-tan coonhound","probability":0.5641617774963379},{"label":"Doberman","probability":0.3869141638278961},{"label":"bluetick","probability":0.012455757707357407},{"label":"Rottweiler","probability":0.007904204539954662},{"label":"Gordon setter","probability":0.006333122029900551}]}%


OpenShift/ROSA instructions (deck to be created) 
1. Build Image from github directly or use the 

Use OpenShift/ROSA to prebuild this image 
gh repo clone emcon33/inference-rosa-workshop

GUI Build Directly in ROSA/OpenShift
Switch to Developer Persona
Add, Github, and add https://github.com/emcon33/inference-rosa-workshop with defaults
Watch the logs build
Once build completes click on the web swizle and it will open a touch page, update the below link for your URL. Be sure you have a local image to upload. 

from your repo director with local test3.jpeg example 
curl -X POST -F image=@test3.jpeg "https://inference-rosa-workshop-test7.apps.rosa-vs2cl.zpq2.p1.openshiftapps.com/api/predict"

Test with other images note not all will work due to size limits and it prefers jpeg/jpg images. 

Use a pre-built image if you have build issues with the build
docker.io/andrewwg/classification_model_serving

Once it is built click on web open on the GUI and you will see a place holder page, upload your image via API with text return. 

or CLI
oc new-project emcon33-waiter
oc run dog-inference --8000:80 andrewwg/classification_model_serving --port 5000
oc expose pod andrewwg/classification_model_serving --port 80 --target-port 5000 

Todo: 
#ArgoCD/Tekton Pipeline 
https://docs.openshift.com/container-platform/4.10/cicd/gitops/setting-up-argocd-instance.html


### References
Original source https://towardsai.net/p/machine-learning/build-and-deploy-custom-docker-images-for-object-recognition
Forked from this github https://github.com/hasibzunair/imagercg-waiter


`
