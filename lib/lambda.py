import json


def handler(event, context):
    print("Incoming event: " + json.dumps(event, indent=2))
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'text/html'
        },
        'body': '<h1>It Worked</h1>'
    }
