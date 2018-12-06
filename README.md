# Description 

This microservice provides a mechanism to collect Junos `show commands` and Junos `configuration` from Junos Devices.  
It uses Ansible. 

# Requirements

Install Docker 

# Inputs

You need to provide 2 files
- An Ansible Inventory file (`inventory.ini`) with following elements:
  - `ansible_host`: IP of the device
  - `netconf_port`: netconf port uses to connect to devices (default is 830)
  - `ansible_ssh_private_key`: Private key to use to authenticate against devices (Optional)
  - `ansible_ssh_user`: Username to use for the connection
  - `ansible_ssh_pass`: Password to use for the connection (Optional if private key is configured)
- A YAML file to indicate the desired format for Junos `configuration`, and the list of desired `show commands`.  

You will find examples below.  

# Usage

Pull the image
```
$ docker pull jnprautomate/junos-command-collector
```
Verify
```
$ docker images jnprautomate/junos-command-collector
REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
jnprautomate/junos-command-collector   latest              e77270e113e8        16 seconds ago      361MB
```
List containers (there is no container)
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```
Create this structure
- inputs directory
   - with an ansible `inventory.ini` file 
   - A YAML file to indicate the desired format for Junos `configuration`, and the list of desired `show commands` .    
- outputs directory
```
$ tree
.
├── inputs
│   ├── collector-details.yml
│   └── inventory.ini
└── outputs

```
Ansible inventory example: 
```
$ more inputs/inventory.ini
[demo]
demo-qfx10k2-14    ansible_host=172.25.90.67
demo-qfx10k2-15    ansible_host=172.25.90.68

[all:vars]
netconf_port=830
ansible_ssh_user=ansible
ansible_ssh_pass=juniper123
#ansible_ssh_private_key = "~/.ssh/id_lab_gsbt"
```

Configure the details you want to collect. Example:   
```
$ more inputs/collector-details.yml

---
dump:
  configuration:
    format: text
  cli:
    - "show chassis hardware"
    - "show version"
```

Run this microservice: This will instanciate a container, execute the service, and remove the container.  
```
$ docker run -it --rm -v ${PWD}/inputs:/inventory -v ${PWD}/outputs:/outputs jnprautomate/junos-command-collector
Collect Junos commands
  > Check inventory file
  > Inventory file found (inputs/inventory.ini)
  > Collect Junos commands

PLAY [collect data from devices] **************************************************************************************************************

TASK [include_vars] ***************************************************************************************************************************
ok: [demo-qfx10k2-15]
ok: [demo-qfx10k2-14]

TASK [collect-configuration : Create output directory for device] *****************************************************************************
changed: [demo-qfx10k2-14]
changed: [demo-qfx10k2-15]

TASK [collect-configuration : Collect configuration in text format from devices] **************************************************************
ok: [demo-qfx10k2-15]
ok: [demo-qfx10k2-14]

TASK [collect-configuration : Copy collected configuration in a local directory] **************************************************************
changed: [demo-qfx10k2-15]
changed: [demo-qfx10k2-14]

TASK [collect-configuration : Collect configuration in set format from devices] ***************************************************************
skipping: [demo-qfx10k2-14]
skipping: [demo-qfx10k2-15]

TASK [collect-configuration : copy collected configuration in a local directory] **************************************************************
skipping: [demo-qfx10k2-14]
skipping: [demo-qfx10k2-15]

TASK [collect-configuration : Collect configuration in json format from devices] **************************************************************
skipping: [demo-qfx10k2-14]
skipping: [demo-qfx10k2-15]

TASK [collect-configuration : copy collected configuration in a local directory] **************************************************************
skipping: [demo-qfx10k2-14]
skipping: [demo-qfx10k2-15]

TASK [collect-configuration : Collect configuration in xml format from devices] ***************************************************************
skipping: [demo-qfx10k2-14]
skipping: [demo-qfx10k2-15]

TASK [collect-configuration : copy collected configuration in a local directory] **************************************************************
skipping: [demo-qfx10k2-14]
skipping: [demo-qfx10k2-15]

TASK [collect-commands : Create output directory for device] **********************************************************************************
ok: [demo-qfx10k2-15]
ok: [demo-qfx10k2-14]

TASK [collect-commands : Pass the junos commands and save the output] *************************************************************************
ok: [demo-qfx10k2-15] => (item=show chassis hardware)
ok: [demo-qfx10k2-14] => (item=show chassis hardware)
ok: [demo-qfx10k2-15] => (item=show version)
ok: [demo-qfx10k2-14] => (item=show version)

PLAY RECAP ************************************************************************************************************************************
demo-qfx10k2-14            : ok=6    changed=2    unreachable=0    failed=0
demo-qfx10k2-15            : ok=6    changed=2    unreachable=0    failed=0
```
The container doesnt exist anymore
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```
Here's the output
```
$ tree
.
├── inputs
│   ├── collector-details.yml
│   └── inventory.ini
└── outputs
    ├── demo-qfx10k2-14
    │   ├── configuration-demo-qfx10k2-14.conf
    │   ├── show chassis hardware.txt
    │   └── show version.txt
    └── demo-qfx10k2-15
        ├── configuration-demo-qfx10k2-15.conf
        ├── show chassis hardware.txt
        └── show version.txt

4 directories, 8 files

```

