# hello, serverless

Continuously deploy a (buggy) Python ~> 3.6 application that
implements a trivial CRUD interface to a collection of plaintext
files.

The client gave the following requirements:

- [![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/feature-rest-api.yml/badge.svg)](.github/workflows/feature-rest-api.yml)
  the application will present a REST API (HTTPS with TLS v.1.2) as the consumer interface

- [![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/feature-lambda.yml/badge.svg)](.github/workflows/feature-lambda.yml).
  it will be deployed using [regional function-as-a-service](terraform/lambda.tf)

- [![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/feature-database.yml/badge.svg)](.github/workflows/feature-database.yml).
  uses a PostgreSQL database at version ~>10

- maintains a cache layer for the database

- requires storage for uploaded data files with a 30-day retention policy

- an automated health check against a test endpoint, scheduled daily

- centralized logging with a 7-day retention policy

- least privilege access model

- the database listener should not be exposed to any other applications or consumers


[![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/unit-tests.yml/badge.svg)](hello.app/hello_test.py)
[Python app](app)







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


