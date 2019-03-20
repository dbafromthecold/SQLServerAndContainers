# SQL Server and Containers

---

### Sponsors

<img src="assets/images/EWU_Logo_240x76.png" size=small border=none/>
</br>
<img src="assets/images/IntelliTect_BlueBlack.png" size=small border=none/>

---

## Andrew Pruski

### SQL Server DBA & Microsoft Data Platform MVP

@fa[twitter] @dbafromthecold <br>
@fa[envelope] dbafromthecold@gmail.com <br>
@fa[wordpress] www.dbafromthecold.com <br>
@fa[github] github.com/dbafromthecold

---

### Session Aim

To give an overview of the different options available to run SQL Server in containers

---

### Container Definition

Containers wrap a piece of software in a complete filesystem that contains everything needed to run: code, runtime, system tools, system libraries – anything that can be installed on a server. This guarantees that the software will always run the same, regardless of its environment. <br>

@size[0.8em](https://www.docker.com/what-docker)

---

### Virtual Machines vs Containers

<img src="assets/images/VmsVsContainers.png" style="float: right;" size=medium border=none/>

---

## Demos

---

## Case Study

---

### Problem

QA/Dev departments repeatedly creating new VMs <br>
All VMs require a local instance of SQL Server <br>
SQL installed from chocolately <br>
30+ databases then restored via PoSH scripts <br>
SQL install taking ~40 minutes from start to finish

---

### Solution

Containers! <br>
Implement containers running SQL Server <br>
SQL containers built from custom image <br>
No longer need to install SQL <br>
No longer need to restore databases <br>
Resources freed up on VMs 

---

### Windocks

A port of the open source project from Docker Inc. <br>
Software supports the creation of containers running earlier versions of SQL Server (2008+) on Windows Server 2008+ <br>
Free Community Edition available 

---

### Architecture

<p align="center">
<img src="assets/images/Windocks.png" size=small border=none/>
</p>

---

### Benefits

New VMs deployed in a fraction of the previous time <br>
No longer need to run PoSH scripts to restore databases <br>
Base image can be used to keep containers at production level <br>
More VMs can be provisioned on host due to each VM requiring less resources 

---

### Issues

Apps using DNS entries to reference local SQL instance <br>
Update to existing test applications <br>
Trial and error to integrate with Octopus deploy <br>
New ways of thinking

---

### Resources

https://github.com/dbafromthecold/SqlServerAndContainers <br>
<br>
https://dbafromthecold.com/2017/03/15/summary-of-my-container-series/
