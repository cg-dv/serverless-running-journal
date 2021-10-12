#resource "aws_amplify_app" "serverless-running-journal" {
#name         = "serverless-example-app"
#repository   = "https://github.com/cg-dv/serverless-running-journal"
#access_token = local.github-token.amplify-github-token
#}

#resource "aws_amplify_branch" "main" {
#app_id            = aws_amplify_app.serverless-running-journal.id
#branch_name       = "main"
#enable_auto_build = true
#}
