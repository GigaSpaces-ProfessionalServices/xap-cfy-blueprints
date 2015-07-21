# xap-cfy-blueprints
XAP Cloudify Blueprints

In order to deploy XAP grid, perform the following steps:

1. Provision Debian-like (apt-get-based, e.g. Ubuntu) Linux machines/VMs with sufficient amount of RAM, ssh access with shared username and password.
RedHat-like OS (with yum) support as well as per-machine configurable credentials will be added later.
2. Copy inputs.yaml.sample to inputs.yaml and populate that with deployment data. For manager_hosts and grid_hosts sections, each list item should correspond to a separate host/node. The sections may contain any number of nodes as long as the IPs correspond to pre-provisioned machines.
3. Process the template blueprint and flatten the input file.
   With the virtualenv activated that has the `cfy` command, run
   ```
   python preprocess.py -p xap.yaml -i inputs.yaml
   ```
   This should create files `xap_processed.yaml` and `inputs_processed.yaml`.
4. Use the created files in Cloudify manager:
```
cfy blueprints upload -p xap_processed.yaml -b $BLUEPRINT_NAME
cfy deployments create -d $DEPLOYMENT_NAME -b $BLUEPRINT_NAME -i inputs_processed.yaml
cfy executions start -d $DEPLOYMENT_NAME -w install
```
Once the install completes, navigate to `http://$MANAGER_IP:9099` to get XAP web UI.
