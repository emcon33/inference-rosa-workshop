# inference-rosa-workshop
# This is a workshop for deploying a Pytorch & FastAPI project to ROSA on AWS and perform inference.

Containerized app that serves a containerized Resnet18 deep learning image classification model using FastAPI. We used an ImageNet pretrained model that can predict 1000 different classes of general objects, the samples are animals but it will work with anything. See class list [here](https://deeplearning.cms.waikato.ac.nz/user-guide/class-maps/IMAGENET/).

Forked from this project for a workshop: https://github.com/hasibzunair/imagercg-waiter
ResNet18 https://www.mathworks.com/help/deeplearning/ref/resnet18.html

#### Todos
* Port to Podman 
* Port to OpenShift/ROSA
* Rebuild as Workshop for AWS ROSA
* Add ArgoCD GitOps Pipeline deployment option 
* Build Frontend (Gradio/Python version issue) 

Sample Backend Input Image: 
<p align="left">
  <a href="#"><img src="./sample.png" width="200"></a> <br />
  <em> 
  </em>
</p>

Sample Text Output:
{"success":true,"predictions":[{"label":"black-and-tan coonhound","probability":0.5641617774963379},{"label":"Doberman","probability":0.3869141638278961},{"label":"bluetick","probability":0.012455757707357407},{"label":"Rottweiler","probability":0.007904204539954662},{"label":"Gordon setter","probability":0.006333122029900551}]}%


OpenShift/ROSA instructions (deck to be created) 
1. Build Image from github directly or use the 

Use OpenShift/ROSA to prebuild this image 
gh repo clone emcon33/inference-rosa-workshop

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


### References
Original source https://towardsai.net/p/machine-learning/build-and-deploy-custom-docker-images-for-object-recognition
Forked from this github https://github.com/hasibzunair/imagercg-waiter


### Local development
To use this code for local development, install the requirements using (make sure Python version is 3.8):
```bash
git clone https://github.com/emcon33/emcon33-waiter
cd emcon33-waiter/backend
pip install -r requirements.txt
```
Now, you're setup!

#### Usage
To launch the FastAPI application locally, run:
```python
python main.py
```

A FastAPI application will run on your local machine. See Swagger UI at `http://127.0.0.1:8000/docs` for more info. To interact with it, open a new terminal and just send a curl request like this:
```bash
curl -X POST -F image=@test1.jpeg "http://127.0.0.1:8000/api/predict"
```

Using the `test1.jpeg` image, the `JSON` response result should look like this, with labels and the probability values for the given image:
```json
{
  "success": true, 
  "predictions": 
  [
    {
      "label": "king penguin", 
      "probability": 0.999931812286377
    }, 
    {
      "label": "guenon", 
      "probability": 9.768833479029126e-06
    }, 
    {
      "label": "megalith", 
      "probability": 8.01052556198556e-06
    }, 
    {
      "label": "cliff", 
      "probability": 7.119778274500277e-06
    }, 
    {
      "label": "toucan", 
      "probability": 6.5011186052288394e-06
    }
  ]
}
```

Or, submit a request using a Python script:
```python
python request.py
```
The result should look like this:
```bash
1. king penguin: 0.9999
2. guenon: 0.0000
3. megalith: 0.0000
4. cliff: 0.0000
5. toucan: 0.0000
```

To try it with any of your own images(`*.jpg`,`*.jpeg`,`*.png`), set path to your image `YOUR_IMG_PATH` and run:
```bash
curl -X POST -F image=@YOUR_IMG_PATH "http://127.0.0.1:8000/api/predict"
```

### Dockerized backend

To containerize the backend, we create a docker image and run 
and instance of the image (a container), using:
```
# build
docker build -t classification_model_serving .
# run
docker run -p 8000:80 --name cls-serve classification_model_serving
```

Now, the model is deployed as an API endpoint in your local machine using docker. Finally, run `curl -X POST -F image=@test1.jpeg "http://0.0.0.0:8000/api/predict"` in your terminal. You should get the same JSON response as above.

#### Push to and test image from Docker Hub
```
# tag
docker tag classification_model_serving hasibzunair/classification_model_serving
# push
docker push hasibzunair/classification_model_serving
# run backend from hub
docker run -p 8000:80 --name cls-serve hasibzunair/classification_model_serving
```

Again, you should be able to run `curl -X POST -F image=@test1.jpeg "http://0.0.0.0:8000/api/predict"` and get the same JSON format predictions.