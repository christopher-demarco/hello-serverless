# nuvalence-interview

Hello, serverless!

Create an AWS Lambda that runs `hello.py` .

## Usage

### Prerequisites

  - Python ~> 3.x
  - Terraform ~> 12.x
  - AWS credentials accessible via `AWS_PROFILE`
  
### Create the app bundle

```
cd bin
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
