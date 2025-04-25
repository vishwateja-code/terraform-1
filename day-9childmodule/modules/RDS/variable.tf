variable "identifier" {
  description = "Unique RDS instance identifier"
  type        = string
}

variable "engine" {
  description = "Database engine (e.g., mysql, postgres)"
  type        = string
}

variable "instance_class" {
  description = "Instance class (e.g., db.t3.micro)"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage (in GB)"
  type        = number
}

variable "username" {
  description = "Master DB username"
  type        = string
}

variable "password" {
  description = "Master DB password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}
