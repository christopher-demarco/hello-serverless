# hello, serverless

[Continuously deploy](.github/workflows/deploy-main.yml) to AWS a
[Python ~> 3.6](tests/integration/python.sh) application that
implements a trivial CRUD interface to a collection of plaintext
files. The following requirements are specified:

[![](https://github.com/christopher-demarco/hello-serverless/actions/workflows/functional-tests.yml/badge.svg)](https://github.com/christopher-demarco/hello-serverless/actions/workflows/functional-tests.yml)

- The application will present a [REST API](terraform/api-gateway.tf)
  (HTTPS with [TLS v.1.2](tests/integration/tls_1.2.sh)) as the
  consumer interface

- It will be deployed using [regional
  function-as-a-service](terraform/lambda.tf)

- TODO uses a PostgreSQL database at version ~>10

- TODO maintains a cache layer for the database

- TODO requires storage for uploaded data files with a 30-day
  retention policy

- TODO an automated health check against a test endpoint, scheduled
  daily

- [centralized logging](tests/integration/lambda-logs.sh) with a [7-day
  retention policy](tests/integration/log-retention.sh)

- [least privilege access model](terraform/lambda.tf)

- TODO the database listener should not be exposed to any other
  applications or consumers


TODO The app is a single file called user_uploads.py

TODO The app requires db credentials and a client API key used to
access a remote service; both are only accessible to the application
from within its runtime

The application does not require regional redundancy or failover
capabilities; otherwise the code should be production-ready , with all
of the considerations implied therein.


## Prerequisites

### GitHub account

If you're forking the repo, you'll need a GitHub account.


### Custom domain

The application is hosted at a domain served by a Route53 public zone.
Registering a domain and creating the zone is outside of the scope of
this project.

Throughout this documentation we refer to your custom domain as
`domain.example`; substitute your actual value.

The value of the custom domain is read from the `TF_VAR_domain` env
var--set by hand in development, and via a [GitHub
Secret](https://docs.github.com/en/actions/reference/encrypted-secrets)
`DOMAIN` in CICD.


### SSL certificate

Because [Amazon's ACM certificate infrastructure is grossly,
inconsistently, and secretly
throttled](https://github.com/aws/aws-cdk/issues/5889), it may be
impractical to use it for development. Therefore [Let's
Encrypt](https://letsencrypt.org) is recommended instead.

You will need to create a wildcard cert for `*.domain.example` using
Let's Encrypt or a SSL provider of your choice. You may want to test
with a fake/staging certificate before committing to a
production-grade cert, to prevent incurring cost or running afoul of
service limits.

Upload the certificate to AWS ACM. Development and CICD workflows will
re-use this certificate for all deployments.

The ACM certificate identifier is looked up via the `TF_VAR_domain`
[variable](#Custom-domain).


### Terraform state bucket

Terraform state is stored in S3. You will need to create a bucket;
specify it via the `TF_VAR_state_bucket` variable in the dev
environment and as a [GitHub
Secret](https://docs.github.com/en/actions/reference/encrypted-secrets)
`STATE_BUCKET` in CICD.


### Dev / CICD environment

  - Python ~> 3.6.x
  - Terraform ~> 12.x
  - AWS credentials accessible via `AWS_PROFILE`
  - [Terragrunt](https://terragrunt.gruntwork.io)
  

## Usage

The project is intended to be deployed via [GitHub
CICD](.github/workflows).


### Manually create the app bundle

```
cd hello.app
make
```


### Manually create cloud infra

```
cd terraform
TF_VAR_domain=your.domain \
TF_VAR_state_bucket=<bucketname> \
TF_VAR_environment=<environment name> \
terragrunt init && terragrunt apply
```

(Note that the `TF_VAR_environment` var may be set to an arbitrary
value if `dev` is not desired--for example, Alice and Bob may want to
build distinct environments so as not to step on each other. See
[Namespace environments by branch](#Namespace-environments-by-branch),
below.)

The variables set via `TF_VAR_` env vars may also be specified via
`tfvars` files, or other methods.


## Developing

Create & push tags using [bin/create-tag.sh](bin/create-tag.sh).


### devenv

See generally [prerequisites](#prerequisites), above.


#### hello.app

A simple python virtualenv: 

```
python3 -mvenv venv
. ./venv/bin/activate
pip install --upgrade pip && pip install --upgrade setuptools
[[ -e requirements.txt ]] && pip install -r requirements.txt
[[ -e build-requirements.txt ]] && pip install -r build-requirements.txt
make test
```


## Design

### Namespace environments by branch

We define an "environment" as a named collection of resources deployed
to AWS, which is managed independently of, and can coexist with,
arbitrarily-many other environments.

We use [Terragrunt](https://terragrunt.gruntwork.io) to automate the
configuration of Terraform state, so that each distinct environment
(`dev` for the developer's local machine, `test` for the automated QA
regime, and `production` for CICD deploys from the `main` branch) can
be create & destroyed independently. Each environment's state is
stored at the `terraform/<env>` key.

AWS resources are likewise named according to environment--e.g. there
will will always be one Lambda (hello-production), but there may be
additionally two others (i.e. hello-test and hello-dev) at any given
point in time.

Environments' service endpoints will generally be of the form
`env.domain.example`, e.g. the REST interface under QA testing will be
found at `https://test.domain.example`.

The environment is set via the env var `TF_VAR_environment`. CICD
workflows set this automatically; the local dev env must set this
explicitly in order for Terragrunt to function properly.


### CICD

Build and deploy tasks, and integration and end-to-end (aka
"functional") tests, are [specified](.github/workflows) as [GitHub
Workflows](https://docs.github.com/en/actions/learn-github-actions).

Because GitHub Actions are billable, we restrict all automated testing
to the `test` branch. A person could force-push to that branch if it's
diverged from `main`.

All merges to `main` [run the full test suite, and upon passing are
promoted to production](.github/workflows/deploy-main.yml).

The `branch` Terraform variable is set automatically in these
workflows; in the local dev env it defaults to `dev`.

#### AWS credentials

Deploy tasks, integration tests, and end-to-end tests require AWS
credentials to be set as [GitHub
Secrets](https://docs.github.com/en/actions/reference/encrypted-secrets)
`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.


## Known issues

- [The app is not named user_uploads.py](https://github.com/christopher-demarco/hello-serverless/issues/79)

- [Undocumented IAM Policy for running Terraform](https://github.com/christopher-demarco/hello-serverless/issues/48)

- [The Lambda is permitted access to all log groups instead of just its own](https://github.com/christopher-demarco/hello-serverless/projects/1#card-61679128)

- [Terragrunt is installed via a ridiculous process](https://github.com/christopher-demarco/hello-serverless/issues/74)

- [The Python version test requires an exact match instead of ~>](https://github.com/christopher-demarco/hello-serverless/issues/60)

- [The functional curl test occasionally fails the first time it's run](https://github.com/christopher-demarco/hello-serverless/issues/78)


-----
Copyright (c) 2021 Christopher DeMarco. All rights reserved.


