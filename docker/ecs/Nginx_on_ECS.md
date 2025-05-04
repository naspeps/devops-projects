###General steps for deloying a docker application on ECS

- Create an ECS cluster
- Register a Task definition
	- a TD carries out container configuration
	- It describes parameters of one or more containers that form an application. 
- Create a service
	- A service instantiates a TD, creating a task (running a container out of the image & details in TD).
	- A task can have multiple containers
- Run application

###Deploying Nginx on AWS ECS

**Create ECS cluster**

- Cluster name 'nginx-cluster'

**Create Task definition**

- Launch type: AWS Fargate, Task size: 1 vCPU, 1GB RAM, Task execution role: ecsTaskExecutionRole
- Container name: nginx, image url: 'nginx:latest', Port mappings: container port = 80
	- Using 'nginx:latest' will search the official public docker repository. You can also use url to private or public images. 

**Create Service**

- ECS → Clusters → nginx-cluster → Services → Create
- Task definition family: 'nginx-demo-td', Launch type: Fargate, # of tasks: 1
- Networking → choose VPC, at leat 2 subnets, SG : allow port 80

**Access Nginx**

- ECS → Clusters → nginx-cluster → Task → Networking → public IP

Note: 
- If you use a public image, make sure ecs service is deployed in a public subnet or that the private subnet has a NAT.
- To stop execution/containers from running, update service and set desired task to 0