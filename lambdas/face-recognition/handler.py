import os
import urllib.parse
import boto3
import numpy as np
import cv2
print('Loading function')

s3 = boto3.client('s3')

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    try:
        response = s3.get_object(Bucket=bucket, Key=key)
        image_data = response['Body'].read()

        image_array = np.frombuffer(image_data, np.uint8)
        mat = cv2.imdecode(image_array, cv2.IMREAD_COLOR)

        image = detect_faces(mat)

        uploadImageToS3(response, image, bucket, key)

        return {
            'statusCode': 200,
            'body': 'Image processed and uploaded successfully!'
        }

    except Exception as e:
        print(e)
        print(
            'Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(
                key, bucket))
        raise e

def detect_faces(image):
    # Convert the image to grayscale (required for face detection)
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # Load the pre-trained Haar Cascade classifier for face detection
    face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")

    # Detect faces in the image
    faces = face_cascade.detectMultiScale(gray_image, scaleFactor=1.1, minNeighbors=5, minSize=(30, 30))

    print(len(faces))
    # Draw rectangles around the detected faces
    for (x, y, w, h) in faces:
        cv2.rectangle(image, (x, y), (x + w, y + h), (255, 0, 0), 2)

    return image

def uploadImageToS3(response, image, bucket_name, key):
    _, buffer = cv2.imencode('.jpg', image)
    processed_image_data = buffer.tobytes()

    # Upload the processed image to a new S3 bucket
    new_bucket = os.environ['S3_PROCESSED_IMAGE_BUCKET']
    new_key = f"processed-{key}"
    s3.put_object(Bucket=new_bucket, Key=new_key, Body=processed_image_data, ContentType=response['ContentType'])

    print(f"Image uploaded to S3 bucket {bucket_name} with object name {new_key}")