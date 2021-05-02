# nuvalence-interview

Hello, serverless!

Create an AWS Lambda that runs `hello.py` .


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

### dev env

### hello.app

A simple python virtualenv: 

```
python3 -mvenv venv
. ./venv/bin/activate
pip install --upgrade pip && pip install --upgrade setuptools
[[ -e requirements.txt ]] && pip install -r requirements.txt
[[ -e build-requirements.txt ]] && pip install -r build-requirements.txt

```
