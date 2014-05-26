//
//  BucketObject.h
//  S3BucketBrowser
//
//  Created by cruinh on 5/11/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BucketObject : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSDate * lastModified;
@property (nonatomic, retain) NSString * eTag;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSString * owner;
@property (nonatomic, retain) NSString * storageClass;
@property (nonatomic, retain) NSManagedObject *bucket;

@end
