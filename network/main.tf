# Call the networkmodule to create network resources for the prod environment.

module "network" {
  source = "../networkModule" # Path to the networkmodule

  env = var.env # Pass the env variable to the network module
}