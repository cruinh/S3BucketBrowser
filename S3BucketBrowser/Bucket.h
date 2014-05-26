//
//  Bucket.h
//  S3BucketBrowser
//
//  Created by cruinh on 5/11/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BucketObject;

@interface Bucket : NSManagedObject

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) BucketObject *objects;

@end
