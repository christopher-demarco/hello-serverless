# nuvalence-interview

Hello, serverless!

Create an AWS Lambda that runs `hello.py` .

## Usage

### Prerequisites

  - Python 3.x
  - Terraform
  - AWS credentials accessible via `AWS_PROFILE`
  
### Create the app bundle

```
cd bin
make zip
cd ..
```

### Create cloud infra

```
cd terraform
tf init
tf apply
cd ..
```


