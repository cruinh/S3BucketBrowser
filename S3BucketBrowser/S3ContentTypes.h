//
//  S3ContentTypes.h
//  S3BucketBrowser
//
//  Created by cruinh on 5/11/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface S3ContentTypes : NSObject

+ (NSSet*)acceptableContentTypes;
+ (NSSet*)imageContentTypes;
+ (NSSet*)textContentTypes;
+ (NSSet*)webContentTypes;
+ (NSSet*)otherContentTypes;

@end
