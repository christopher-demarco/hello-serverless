# get_env(NAME)

remote_state {
  backend = "s3"
  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = get_env("TF_VAR_state_bucket")
    key = "terraform/${get_env("TF_VAR_environment")}"
    region = "us-west-2"
  }
}
