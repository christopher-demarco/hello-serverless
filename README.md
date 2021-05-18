# hello, serverless

[](https://github.com/christopher-demarco/hello-serverless/actions/workflows/functional-tests.yml/badge.svg)

Continuously deploy a Python ~> 3.6 application that implements a
trivial CRUD interface to a collection of plaintext files. The
following requirements are specified:

- DONE The application will present a [REST API](terraform/api-gateway.tf)(HTTPS with TLS v.1.2) as the consumer interface
  [![](https://github.com/christopher-demarco/hello-serverless/actions/workflows/feature-rest-api.yml/badge.svg)](.github/workflows/feature-lambda.yml)

- DONE it will be deployed using [regional function-as-a-service](terraform/lambda.tf)
  [![](https://github.com/christopher-demarco/hello-serverless/actions/workflows/feature-lambda.yml/badge.svg)](.github/workflows/feature-lambda.yml)

- TODO uses a PostgreSQL database at version ~>10

- TODO maintains a cache layer for the database

- TODO requires storage for uploaded data files with a 30-day retention policy

- TODO an automated health check against a test endpoint, scheduled daily

- TODO centralized logging with a 7-day retention policy

- TODO least privilege access model

- TODO the database listener should not be exposed to any other applications or consumers


The app is a single file called [user_uploads.py](app/user_uploads.py]
[![](https://github.com/christopher-demarco/hello-serverless/actions/workflows/unit-tests.yml/badge.svg)](app/hello_test.py).

TODO The app requires db credentials and a client API key used to
access a remote service; both are only accessible to the application
from within its runtime 
.

The application does not require regional redundancy or failover
capabilities; otherwise the code should be production-ready
, with all
of the considerations implied therein.



## Usage

### Prerequisites

  - Python ~> 3.6.x
  - Terraform ~> 12.x
  - AWS credentials accessible via `AWS_PROFILE`
  
Additionally, you will need a domain hosted by a Route53 public zone.
Registering and creating is outside of the scope of this project. The
domain to be used is read from the `TF_VAR_domain` env var--set by
hand in development, and via a [GitHub
Secret](https://docs.github.com/en/actions/reference/encrypted-secrets)
in CICD.


**WARNING**: The S3 bucket where Terraform state is stored is hard-coded.
Create a bucket and specify it [in the codebase](terraform/aws.tf)
before running.


### Create the app bundle

```
cd hello.app
make
```


### Create cloud infra

```
cd terraform
terraform init # this is only necessary the first time
TF_VAR_domain=your.domain terraform apply
```

## Developing

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

### Intent first--automate the testing of your premises.

This is an attempt at a self-documenting project.

Code, tooling, workflows, engagement--all should work in harmony
toward an ultimate goal: If such-and-such tests pass, you're done.
What are the acceptance criteria by which we're paid? 

We write functional tests first: Because they're
failing--automatically, via cicd--we know we're not done. We don't
need to know how to execute them (`/bin/false` is a useful
placeholder), we can write tests as we go for a service as we figure
out how to implement it. Bugs, defects, and various problems are
documented (in tests) as they're encountered.

Now the reader of the README knows how "complete" the project is. All
of the tooling is in service of the ultimate goal: To make the
customer feel confident that everything's functioning as expected.


### Namespace by branch

Unshareable resources--the DNS name and API Gateway
[stage](https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-deploy-api.html)
are namespaced by branch. The branchname is specified in a Terraform
[variable](terraform/vars.tf) `branch`. 

On the local dev machine, this is set to `dev`; override by setting
the env var `TF_VAR_branch`.


### CICD

Build and deploy tasks, and integration and end-to-end (aka
"functional") tests, are [specified](.github/workflows) as [GitHub
Workflows](https://docs.github.com/en/actions/learn-github-actions).

Because GitHub Actions are billable, we restrict all automated testing
to the `test` branch. A person could force-push to that branch if it's
diverged from `main`.

All merges to `main` run the full test suite, and upon passing are
promoted to production.

The `branch` Terraform variable is set automatically in these
workflows; in the local dev env it defaults to `dev`.

#### AWS credentials

Deploy tasks, integration tests, and end-to-end tests require AWS
credentials to be set as [GitHub
Secrets](https://docs.github.com/en/actions/reference/encrypted-secrets).

-----
Copyright (c) 2021 Christopher DeMarco. All rights reserved.
