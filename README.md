# hello, serverless

Continuously deploy a Python ~> 3.6 application that implements a
trivial CRUD interface to a collection of plaintext files. The client
gave the following requirements:

- TODO the application will present a REST API (HTTPS with TLS v.1.2) as the consumer interface

- it will be deployed using [regional function-as-a-service](terraform/lambda.tf)
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
  
### Create the app bundle

```
cd hello.app
make
cd ..
```


### Create cloud infra

```
cd terraform
tf init
tf apply
cd ..
```

# Known issues




# Design

This is an attempt at a self-documenting project.

### Intent first. Automate testing your premises.

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

### Lead the reader.

Be friendly and useful. Make it obvious what to do next.
Link generously.
Increase detail and verbosity with depth in codebase.



## Developing

### devenv

#### hello.app

A simple python virtualenv: 

```
python3 -mvenv venv
. ./venv/bin/activate
pip install --upgrade pip && pip install --upgrade setuptools
[[ -e requirements.txt ]] && pip install -r requirements.txt
[[ -e build-requirements.txt ]] && pip install -r build-requirements.txt
```

`make test`


## CICD

[Force, if necessary] push to `test`, and expensive integration and
e2e tests will be run.

All merges to `main` run the full test suite, and upon passing are
promoted to production.


-----
Copyright (c) 2021 Christopher DeMarco. All rights reserved.
