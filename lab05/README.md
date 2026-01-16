# Lab05 - Networking Environment
In this lab, I go over setting up a virtual network, breaking it down into various subnets as well securing selected subnets using a network security group. This lab focuses on dynamic subnetting, automated security rules based on real-time data, and integrating enterprise-level logging.

## Architecture 

![Architecture Diagram](/lab05/images/network-diagram.png)

### 🏗️ Architecture Overview
The configuration deploys the following resource hierarchy:

1. Resource Group: A container for all resources being deployed.

2. Virtual Network (VNET): Uses a variable-driven address space.

3. Subnet Segmentation: Four subnets (alpha, bravo, charlie, and delta) are derived from the base CIDR block.

4. Security Layer:

    * A Network Security Group (NSG) configured for inbound SSH (Port 22).

    * The rule dynamically permits access only from the IP address of the person running the Terraform plan.

    * The NSG is associated specifically with the alpha subnet.

5. Monitoring: A diagnostic setting connects the VNET to an existing observability workspace to capture allLogs and AllMetrics.

## 🚀 Key Features

* Dynamic Subnetting: Uses Terraform locals and the cidrsubnet function to programmatically carve a base VNET address space into four equal segments.

* Contextual Security: Automatically fetches the developer's public IP address at runtime to create a "least-privilege" SSH security rule.

* Infrastructure Observability: Implements diagnostic settings to stream all network logs and metrics to a centralized Log Analytics Workspace.

* Naming Standards: Follows a consistent naming convention (e.g., rg-, vnet-, snet-) using variables for application and environment context.