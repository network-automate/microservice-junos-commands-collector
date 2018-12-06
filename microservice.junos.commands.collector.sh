#!/bin/sh

cd /
echo "Collect Junos commands"

echo "  > Check inventory file"
if [ -f "inventory/inventory.ini" ]
then
	echo "  > Inventory file found (inputs/inventory.ini)"
	echo "  > Collect Junos commands"
	ansible-playbook  pb.tools.junos.collect.commands.yaml -i inventory/inventory.ini
else
	echo "  ! No inventory file found, aborting"
fi
