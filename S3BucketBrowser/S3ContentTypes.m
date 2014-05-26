//
//  S3ContentTypes.m
//  S3BucketBrowser
//
//  Created by cruinh on 5/11/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import "S3ContentTypes.h"

@implementation S3ContentTypes

+ (NSSet*)acceptableContentTypes
{
    NSSet *completeSet = [NSMutableSet setWithSet:[self imageContentTypes]];
    completeSet = [completeSet setByAddingObjectsFromSet:[self textContentTypes]];
    completeSet = [completeSet setByAddingObjectsFromSet:[self webContentTypes]];
    completeSet = [completeSet setByAddingObjectsFromSet:[self otherContentTypes]];
    return completeSet;
}

+ (NSSet*)imageContentTypes
{
    return [NSSet setWithArray:@[@"image/png",@"image/jpeg",@"image/gif",@"image/bmp",@"image/tif",@"image/ico",@"image/cur",@"image/xmb"]];
}

+ (NSSet*)textContentTypes
{
    return [NSSet setWithArray:@[@"text/plain"]];
}

+ (NSSet*)webContentTypes
{
    return [NSSet setWithArray:@[@"text/html"]];
}

+ (NSSet*)otherContentTypes
{
    return [NSSet setWithArray:@[@"application/xml"]];
}

@end
