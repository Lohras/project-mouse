This tf code creates the S3 bucket and gives the permission to sns to notify whenever there is a object gets uploaded to the s3 bucket

Subscription is made to my email in variable.tf file , can be changed to whatever email which is given

Since terraform partially supports the sns subscription , we have to manually subscribe once the sns subscription is created

