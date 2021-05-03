# nuvalence-interview

Present a [Python app](app)
[![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/unit-tests.yml/badge.svg)](hello.app/hello_test.py)
over a REST API
[![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/feature-rest-api.yml/badge.svg)](.github/workflows/feature-rest-api.yml)
deployed as an AWS Lambda
[![](https://github.com/christopher-demarco/nuvalence-interview/actions/workflows/feature-lambda.yml/badge.svg)](.github/workflows/feature-lambda.yml).



FIXME: Link to implementation throughout



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


