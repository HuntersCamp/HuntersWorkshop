# Create Exoscale Lab

Getting started with Exoscale!

## Create Account

Create account at: https://www.exoscale.com/ top up your credits or use your coupon code.

## Create Private Network

Create new private network under: `Compute > Private Network > CH-DK-2 > Allocate`

Name: `Internal`

## Create Firewall Groups

Create firewall groups under: `Compute > Firewalling > Add`

### Jumphost

| Type    | Protocol | Source Type | Source    | Ports          |
| ------- | -------- | ----------- | --------- | -------------- |
| Ingress | TCP      | CIDR        | 0.0.0.0/0 | 3389           |
| Ingress | ICMP     | CIDR        | 0.0.0.0/0 | Type 8, Code 0 |

### Internal

| Type    | Protocol | Source Type    | Source    | Ports          |
| ------- | -------- | -------------- | --------- | -------------- |
| Ingress | TCP      | Security Group | Jumphost  | 22             |
| Ingress | TCP      | Security Group | Gateway   | 22             |
| Egress  | ICMP     | CIDR           | 0.0.0.0/0 | Type 8, Code 0 |

### Gateway

| Type    | Protocol | Source Type    | Source   | Ports |
| ------- | -------- | -------------- | -------- | ----- |
| Ingress | TCP      | Security Group | Jumphost | 22    |

## Create Instances

Now that we have configured everything that we need we can create our instances:

### JMP

| Hostname        | jmp                 |
| --------------- | ------------------- |
| Template        | Windows Server 2019 |
| Instance Type   | Medium              |
| Disk            | 50 GB               |
| Zone            | CH-DK-2             |
| Private Network | Internal            |
| IPv6            | Disabled            |
| Security Groups | Jumphost            |

**After Setup Steps**

1. Connect via RDP
2. Create personal user
3. Add personal user to admin group
4. Set IP `192.168.40.50/24` on local interface
5. Copy software ZIP on the host

### GW

| Hostname        | gw         |
| --------------- | ---------- |
| Template        | Centos 7.6 |
| Instance Type   | Medium     |
| Disk            | 50 GB      |
| Zone            | CH-DK-2    |
| Private Network | Internal   |
| IPv6            | Disabled   |
| Security Groups | Gateway    |

**After Setup Steps**

1. Connect via SSH
2. Create personal user
3. Add personal user to wheel group

### ELK

| Hostname        | elk        |
| --------------- | ---------- |
| Template        | Centos 7.6 |
| Instance Type   | Large      |
| Disk            | 50 GB      |
| Zone            | CH-DK-2    |
| Private Network | Internal   |
| IPv6            | Disabled   |
| Security Groups | Internal   |

**After Setup Steps**

1. Connect via SSH
2. Create personal user
3. Add personal user to wheel group