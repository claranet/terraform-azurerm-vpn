locals {
  public_ip_count = var.active_active && var.public_ip_count < 2 ? 2 : var.public_ip_count
}
