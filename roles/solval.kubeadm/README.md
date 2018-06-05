Role Name
=========

Installs Kubeadm

Requirements
------------

None

Role Variables
--------------

```
kubeadm_cgroup_driver: defaults to cgroupfs
kubeadm_cluster_dns: default 10.96.0.10
kubeadm_cluster_domain: default cluster.local
```

Dependencies
------------

None

Example Playbook
----------------

    - hosts: servers
      roles:
         - role: solval.kubeadm

License
-------

Apache 2.0

Author Information
------------------

Jakub Dlugolecki
