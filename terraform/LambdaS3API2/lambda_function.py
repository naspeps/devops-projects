import json
import boto3
import base64
import uuid
import os

s3 = boto3.client('s3')
bucket_name = os.environ['BUCKET_NAME']

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])
        file_content_base64 = body.get('file', None)
        file_name = body.get('filename', f"{uuid.uuid4()}.txt")

        if not file_content_base64:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'File content is required'})
            }

        # Décoder le contenu Base64
        file_content = base64.b64decode(file_content_base64)

        # Stocker dans S3
        s3.put_object(Bucket=bucket_name, Key=file_name, Body=file_content)

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'File uploaded successfully', 'file_name': file_name})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }