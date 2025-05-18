
### Install Jenkins on a Linux server (EC2)

- https://www.jenkins.io/doc/book/installing/linux/#debianubuntu

Install java (OpenJDK21)
sudo apt update
sudo apt install fontconfig openjdk-21-jre
java -version

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins

### Setting up a basic CI pipeline configuration in Jenkins

https://github.com/hkhcoder/vprofile-project/tree/atom


Nexus - Artifacts repository
SonarQube - Code analysis. Check code against best practices, for vulnerabilities, bugs etc.. Other tools iclude Checkstyle, Owasp

- Jenkins dashboard -> New item -> Pipeline -> Pipeline script

Remarks:
- Do not put any comments '#' in the pipeline code, else it fails


### Setting up a second Jenking agent to distribute tasks

Configure a Jenkins server to use a second Jenkins agent (slave) in an EC2, to distribute tasks and optimize resource usage. The two should be able to communicate.


- Provision a second EC2 instance and use same Jenkins SG
	- Modif the Jenkins SG to allow SSH inbound form the Jenkins SG itself
- Dashboard -> Manage Jenkins -> Nodes -> New node -> Permanent agent -> Create
- Node configuration
	- Remote root directory: /home/ubuntu/
	- Labels(optional): linux
	- Launch method: "Launch agents via SSH"
	- Host: Jenkins master Public IP
	
- Add agent's SSH credentials
	- Kind: SSH Username with private key
	- Generate a SSH key pair on the EC2 agent or use an existing key pair.
	- name: ubuntu (or according to os username)
	- Private key -> Enter directly -> Copy and paste the agent ec2 .pem key file content
	- Host Key verification strategy: "Manually trusted key verificaitons trategy"
	Else you get this error:
	/var/lib/jenkins/.ssh/known_hosts [SSH] No Known Hosts file was found at /var/lib/jenkins/.ssh/known_hosts. Please ensure one is created at this path and that Jenkins can read it.
	Key exchange was not finished, connection is closed.
	
	**Note: 
	- To use the same SG for both EC2 and allow communication through 22 between them by referencing the SG as source for SSH, SSH will work only via private IPs not public IPs.
	In AWS, Security Group (SG) references for inbound traffic only work if the instances are in the same VPC and are using private IPs or Security Group IDs for communication.
	


### Automate Jenkins Agent launching with EC2 plugin

To automatically launch and terminate EC2 instances as Jenkins agents, you can install and configure the EC2 Plugin:

Install EC2 Plugin:

- In Jenkins, go to Manage Jenkins > Manage Plugins.

- Install the Amazon EC2 plugin.

Configure EC2 Cloud:

- Go to Manage Jenkins > Configure System.

- Scroll to the Cloud section, and click on Add a new cloud > Amazon EC2.

- Configure your AWS credentials and EC2 settings (region, instance type, AMI, etc.).

- Set up Jenkins to launch EC2 instances on demand as slaves, using the desired instance type, security groups, and SSH credentials.