This repository can be used to deploy a web server that will host static content. You will need to provide a filesystem location that contains your content using an environment variable. By default the server will be running in a VM. Optionally the same VM can be used to build a Docker image and to run a container. Please ensure you have met [these VM requirements](https://github.com/GPII/qi-development-environments/#requirements) before proceeding.

## Use a VM

The ``VM_HOST_DIR`` environment variable should be used to point to a directory containing the content that needs to be served.

```
export VM_HOST_DIR=/your/project/directory/on/the/host/os
vagrant up
```
By default the VM will use port ``8888`` so you will need to make sure a process is not using that port before starting the VM. Alternatively a different port can be specified using the ``VM_HOST_TCP_PORT`` environment variable.

The server can be accessed by visiting the ``http://localhost:8888`` URL. 

## Build a Docker image

A Docker image can be built using the following commands:

```
vagrant ssh
cd /srv
sudo docker build --no-cache -t yourname/web-server .
```
The content made available to the VM above can be found in the ``/srv/www`` directory. This content will be copied to the Docker image.

## Start a Docker container

To start a container you should first stop the web server running in the VM to avoid a port conflict:

```
vagrant ssh
sudo systemctl stop nginx.service
```
Then start a container:

```
sudo docker run \
--name web-server \
-d \
-p 80:80 \
yourname/web-server 
```