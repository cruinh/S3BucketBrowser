//
//  S3Manager.m
//  S3BucketBrowser
//
//  Created by cruinh on 5/10/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import "S3Manager.h"
#import "AFOnoResponseSerializer.h"
#import "S3ContentTypes.h"

@implementation S3Manager

static S3Manager* s_instance = nil;
+ (S3Manager*)sharedInstance
{
    return s_instance;
}

+ (S3Manager*)createSharedInstanceWithAccessKeyID:(NSString*)accessKeyID andSecret:(NSString*)secret
{
    s_instance = (S3Manager *) [[S3Manager alloc] initWithAccessKeyID:accessKeyID secret:secret];
    s_instance.requestSerializer.region = AFAmazonS3USStandardRegion;
    s_instance.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    s_instance.responseSerializer.acceptableContentTypes = [S3ContentTypes acceptableContentTypes];
    return s_instance;
}

- (void)setBucketName:(NSString *)bucketName
{
    _bucketName = bucketName;
    s_instance.requestSerializer.bucket = bucketName;
}

@end
