variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Managed = "Terraform"
  }
}

variable "subscription" {
  description = "Subscription name/identifier (e.g., prod, staging, dev)"
  type        = string
}

variable "region" {
  description = "Azure region (e.g., us-east-1, westeurope)"
  type        = string
}
