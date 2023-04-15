# main.tf

module "my_vm" {
  source = "/home/gabriel/Documentos/github/terraform-modules//instance"

  # Passe as tags para o módulo
  vm_tags = ["my-vm-tag"]
}
