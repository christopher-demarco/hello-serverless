#!/usr/bin/env python

import json

def main(event, context):
    body = json.dumps(f"Hello, world!")
    return {
        'statusCode': 200,
        'body': body
    }

if __name__ == '__main__':
    out = main(None, None)['body']
    print(out)
