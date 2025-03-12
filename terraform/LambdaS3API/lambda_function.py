import os
import json
import boto3
import uuid

s3_client = boto3.client('s3')
bucket_name = os.environ['BUCKET_NAME']

def lambda_handler(event, context):
    body = json.loads(event['body'])
    file_content = body['content']
    file_name = str(uuid.uuid4()) + '.txt'

    s3_client.put_object(
        Bucket=bucket_name,
        Key=file_name,
        Body=file_content
    )

    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'Data stored successfully in S3'})
    }
