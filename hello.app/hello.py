#!/usr/bin/env python

import json

def main(event, context):
    return {
        'statusCode': 200,
        'body': json.dumps("Hello, world!")
    }

if __name__ == '__main__':
    print(main(None, None)['body'])
