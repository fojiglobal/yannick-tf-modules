module "test" {
  source = "github.com/fojiglobal/clovis-tf-modules//test"
  vpc_cidr = "10.25.0.0/16"
  env = "test"
}