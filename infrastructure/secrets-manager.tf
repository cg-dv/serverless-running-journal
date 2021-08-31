data "aws_secretsmanager_secret_version" "authToken" {
  secret_id = "amplify-github-token"
}

locals {
  github-token = jsondecode(
    data.aws_secretsmanager_secret_version.authToken.secret_string
  )
}
