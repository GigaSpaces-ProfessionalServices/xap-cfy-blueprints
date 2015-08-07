# xap-cfy-blueprints
XAP Cloudify Blueprints

In order to deploy XAP grid, perform the following steps:

1. Provision Debian-like (apt-get-based, e.g. Ubuntu) Linux machines/VMs with sufficient amount of RAM, ssh access with shared username and password.
RedHat-like OS (with yum) support as well as per-machine configurable credentials will be added later.
2. Set up 2 instances of Cloudify host pool service. One will be used for manager hosts, the other one will serve GSA hosts.
3. Copy inputs.yaml.sample to inputs.yaml and populate that with deployment data.
4. Use the created files in Cloudify manager:
```
cfy blueprints upload -p xap.yaml -b $BLUEPRINT_NAME
cfy deployments create -d $DEPLOYMENT_NAME -b $BLUEPRINT_NAME -i inputs.yaml
cfy executions start -d $DEPLOYMENT_NAME -w install
```
Once the install completes, navigate to `http://$MANAGER_IP:9099` to get XAP web UI.
