provider "aws" {
  region = var.aws_region
  profile = "iam-prog-access-dev"
  shared_credentials_file = "~/.aws/credentials"
  # Linux:::  $HOME/.aws/credentials
  # windows::: %USERPROFILE%\.aws\credentials
}