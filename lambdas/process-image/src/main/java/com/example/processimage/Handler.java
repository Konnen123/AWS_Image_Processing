package com.example.processimage;

import com.amazonaws.auth.DefaultAWSCredentialsProviderChain;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.S3Event;
import com.amazonaws.services.lambda.runtime.events.models.s3.S3EventNotification;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.S3Object;

import java.awt.image.BufferedImage;
import java.io.InputStream;

public class Handler implements RequestHandler<S3Event, String>
{
    private static final AmazonS3 s3Client = AmazonS3Client.builder()
            .withCredentials(new DefaultAWSCredentialsProviderChain())
            .build();

    @Override
    public String handleRequest(S3Event s3Event, Context context)
    {
        final LambdaLogger logger = context.getLogger();
        if(s3Event == null || s3Event.getRecords() == null || s3Event.getRecords().isEmpty())
        {
            logger.log("No records found in the S3 event");
            return "No records found";
        }

        for(S3EventNotification.S3EventNotificationRecord record : s3Event.getRecords())
        {
            String bucketName = record.getS3().getBucket().getName();
            String objectKey = record.getS3().getObject().getKey();

            logger.log("Processing file: " + objectKey + " from bucket: " + bucketName);

            S3Object s3Object = s3Client.getObject(bucketName, objectKey);
            InputStream objectContent = s3Object.getObjectContent();
            BufferedImage image = null;

            try
            {
                image = javax.imageio.ImageIO.read(objectContent);
                logger.log("Image dimensions: " + image.getWidth() + "x" + image.getHeight());
            }
            catch(Exception e)
            {
                logger.log("Error processing image: " + e.getMessage());
                return "Error processing image";
            }
            finally
            {
                try
                {
                    objectContent.close();
                }
                catch(Exception e)
                {
                    logger.log("Error closing S3 object content: " + e.getMessage());
                }
            }
        }

        return "Image processed successfully";
    }
}
