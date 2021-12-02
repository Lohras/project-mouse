*******
$  <> - this denotes the command which has to be executed locally

*****
1. After pulling this repository from the git , please set below environment variable to have the architecture created

terraform expects below variable to be present in any form , since it is a sensitive content we are 
passing this in env variable

$ export AWS_ACCESS_KEY_ID= "AccountKey"
$ export AWS_SECRET_ACCESS_KEY= "AccountSecret"

2. vpc is sourced to ec2 , hence ec2 is the root module so all the terraform commands has to be run from ec2 as a base

3. $ pwd --> check if the directory points to project-mouse/ec2

$ terraform init 
$ terraform validate
$ terraform plan -o tfplan.state
$ terraform apply "tfplan.state"

4. Once the above commands are executed , there will be listed with IP's where publicinstance IP and NAT instance IP
can be ssh'd from outside world but private instance will work from the nat instance

5 . Make a note of the IP's and copy the ssh public key value to any file locally and change the perimission of the file to 600
and execute below command from the local machine

ssh -i <sshkeycopied file>  ec2-user@<IP of the instance>
