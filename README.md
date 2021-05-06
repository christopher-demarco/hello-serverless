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
