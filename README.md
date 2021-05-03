# hello, serverless

Continuously deploy a Python ~> 3.6 application that implements a
trivial CRUD interface to a collection of plaintext files. The client
gave the following requirements:

- the application will present a REST API (HTTPS with TLS v.1.2) as the consumer interface
  [![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/feature-rest-api.yml/badge.svg)](.github/workflows/feature-rest-api.yml)

- it will be deployed using [regional function-as-a-service](terraform/lambda.tf)
  [![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/feature-lambda.yml/badge.svg)](.github/workflows/feature-lambda.yml)

- uses a PostgreSQL database at version ~>10
  [![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/feature-database.yml/badge.svg)](.github/workflows/feature-database.yml)

- maintains a cache layer for the database
  [![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/feature-cache.yml/badge.svg)](.github/workflows/feature-cache.yml)

- requires storage for uploaded data files with a 30-day retention policy
  [![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/feature-cache.yml/badge.svg)](.github/workflows/feature-cache.yml)

- an automated health check against a test endpoint, scheduled daily
  [![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/feature-healthcheck.yml/badge.svg)](.github/workflows/feature-healthcheck.yml)

- centralized logging with a 7-day retention policy
  [![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/feature-logging.yml/badge.svg)](.github/workflows/feature-logging.yml)

- least privilege access model
  [![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/feature-least-privilege.yml/badge.svg)](.github/workflows/feature-least-privilege.yml)

- the database listener should not be exposed to any other applications or consumers
  [![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/feature-database.yml/badge.svg)](.github/workflows/feature-database.yml)


The app is a single file called [user_uploads.py](app/user_uploads.py]
[![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/unit-tests.yml/badge.svg)](app/hello_test.py).
The app requires db credentials and a client API key used to
access a remote service; both are only accessible to the application
from within its runtime 
[![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/feature-secrets.yml/badge.svg)](.github/workflows/feature-secrets.yml)
.

The application does not require regional redundancy or failover
capabilities; otherwise the code should be production-ready
[![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/feature-production.yml/badge.svg)](.github/workflows/feature-production.yml)
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


## Design

The Python code is bundled as a zipfile for convenience, as a runtime
image would be overkill.


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


-----
Copyright (c) 2021 Christopher DeMarco. All rights reserved.
