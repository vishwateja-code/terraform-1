# Primary region provider
provider "aws" {
  alias  = "primary"
  region = "ap-south-1"
}

# Secondary region provider
provider "aws" {
 alias  = "secondary"
 region = "ap-southeast-1"
}