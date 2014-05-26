//
//  S3Manager.h
//  S3BucketBrowser
//
//  Created by cruinh on 5/10/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFAmazonS3Manager.h"

@interface S3Manager : AFAmazonS3Manager

+ (S3Manager*)sharedInstance;
+ (S3Manager*)createSharedInstanceWithAccessKeyID:(NSString*)accessKeyID andSecret:(NSString*)secret;

@property (nonatomic, strong) NSString *bucketName;

@end
