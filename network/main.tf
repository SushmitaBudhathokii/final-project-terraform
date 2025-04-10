# Call the networkmodule to create network resources for the prod environment.

module "network" {
  source = "../../networkmodule" # Path to the networkmodule

  env = var.env # Pass the env variable to the network module
}