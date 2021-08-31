openstack flavor create m1.nano --ram 128 --disk 1 --vcpu 1
openstack user create demo --password admin --domain default
openstack user create alt_demo --password admin --domain default
openstack project create demo --domain default
openstack role add member --user demo --user-domain default --project demo --project-domain default
openstack role add member --user alt_demo --user-domain default --project demo --project-domain default
